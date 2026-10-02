import 'dart:typed_data';

class Diagnosis {
  const Diagnosis({
    required this.issue,
    required this.cure,
    required this.disclaimer,
    this.provider,
    this.id,
    this.plantId,
    this.createdAt,
    this.imageUrl,
  });
  final String issue, cure, disclaimer;
  final String? provider;

  /// API path of the saved photo (`/api/v1/diagnoses/{id}/image`), when the
  /// server kept it. Needs the Bearer token: load via ApiClient.fetchBytes.
  final String? imageUrl;

  /// Set for diagnoses that came from the backend (saved scans).
  final String? id;
  final String? plantId;
  final DateTime? createdAt;
}

/// One AI reply.
class BotReply {
  const BotReply({
    required this.text,
    this.plantName,
    this.diagnosis,
    this.suggestedChips = const [],
    this.provider,
  });
  final String text;
  final String? plantName;
  final Diagnosis? diagnosis;
  final List<String> suggestedChips;
  final String? provider;
}

class ChatMessage {
  ChatMessage({
    required this.fromUser,
    required this.text,
    this.imageBytes,
    this.diagnosis,
    this.suggestedChips = const [],
    this.provider,
    this.isStreaming = false,
    this.diagnosisId,
    this.imageUrl,
    String? id,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  factory ChatMessage.user(String text, {Uint8List? imageBytes}) =>
      ChatMessage(fromUser: true, text: text, imageBytes: imageBytes);
  factory ChatMessage.bot(BotReply r) => ChatMessage(
    fromUser: false,
    text: r.text,
    diagnosis: r.diagnosis,
    suggestedChips: r.suggestedChips,
    provider: r.provider ?? r.diagnosis?.provider,
  );

  final String id;
  final bool fromUser;
  final String text;
  final Uint8List? imageBytes;
  final Diagnosis? diagnosis;
  final List<String> suggestedChips;
  final String? provider;

  /// True while the reply is still arriving (the bubble shows a caret).
  final bool isStreaming;

  /// The saved scan this turn belongs to (a photo sent from the chat, or a
  /// scan the question was about).
  final String? diagnosisId;

  /// API path of that scan's photo. Messages sent in this run also carry
  /// [imageBytes] and show those instead of downloading.
  final String? imageUrl;

  ChatMessage copyWith({
    String? text,
    String? provider,
    bool? isStreaming,
    String? diagnosisId,
    String? imageUrl,
  }) =>
      ChatMessage(
        id: id,
        fromUser: fromUser,
        text: text ?? this.text,
        imageBytes: imageBytes,
        diagnosis: diagnosis,
        suggestedChips: suggestedChips,
        provider: provider ?? this.provider,
        isStreaming: isStreaming ?? this.isStreaming,
        diagnosisId: diagnosisId ?? this.diagnosisId,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

/// A saved scan the user wants to talk about ("Ask AI Doctor" on the scan
/// result screen): shown above the chat input as a context chip, and its id
/// is sent with the next message so the model knows the result.
class ChatSeed {
  const ChatSeed({
    required this.diagnosisId,
    required this.issue,
    this.imageBytes,
    this.imageUrl,
  });

  /// Null when the scan was not saved by the server (nothing to refer to).
  static ChatSeed? fromScan(Diagnosis? d, Uint8List? imageBytes) {
    final id = d?.id;
    if (d == null || id == null || id.isEmpty) return null;
    return ChatSeed(
      diagnosisId: id,
      issue: d.issue,
      imageBytes: imageBytes,
      imageUrl: d.imageUrl,
    );
  }

  final String diagnosisId;
  final String issue;
  final Uint8List? imageBytes;
  final String? imageUrl;

  /// [issue] without trailing punctuation, to drop into a sentence.
  String get issueLabel => issue.replaceAll(RegExp(r'[.\u0964\s]+$'), '');
}

/// One saved conversation, as listed in the chat history menu.
class ChatSession {
  const ChatSession({
    required this.id,
    required this.title,
    required this.lastMessageAt,
    this.messageCount = 0,
  });

  final String id;

  /// First user message of the conversation (may be empty).
  final String title;
  final DateTime lastMessageAt;
  final int messageCount;
}

/// What a streamed chat reply emits, in order: [ChatStreamStart], any number
/// of [ChatStreamDelta], then [ChatStreamDone] or [ChatStreamError].
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

class ChatStreamStart extends ChatStreamEvent {
  const ChatStreamStart(this.assistantId);

  /// Id the stored assistant message will have.
  final String assistantId;
}

class ChatStreamDelta extends ChatStreamEvent {
  const ChatStreamDelta(this.text);
  final String text;
}

class ChatStreamDone extends ChatStreamEvent {
  const ChatStreamDone({required this.text, this.provider});

  /// The complete stored reply (authoritative over the concatenated deltas).
  final String text;
  final String? provider;
}

/// The server cut the reply short. Text received so far was also stored.
class ChatStreamError extends ChatStreamEvent {
  const ChatStreamError({required this.code, required this.message});
  final String code;
  final String message;

  bool get isRateLimited => code == 'rate_limited';
}

/// A live streamed reply. Errors that happen before the first byte (HTTP
/// errors, no connection) arrive as errors on [events] ([Failure]);
/// [cancel] aborts the request and ends [events] quietly.
class ChatStream {
  const ChatStream(this.events, this.cancel);
  final Stream<ChatStreamEvent> events;
  final void Function() cancel;
}
