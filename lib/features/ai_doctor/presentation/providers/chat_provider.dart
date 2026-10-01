import 'dart:math';

import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/model/chat_models.dart';
import '../../domain/repositories/ai_doctor_repository.dart';

class ChatController extends ChangeNotifier {
  ChatController(this._repo, this._storage) : sessionId = _newSessionId();
  final AiDoctorRepository _repo;
  final SecureStorage _storage;

  /// Sent with every chat message so the backend keeps one history per
  /// conversation. It is persisted (see [loadHistory]) so the conversation
  /// survives app restarts, and dropped on logout (see [reset]).
  String sessionId;
  bool _historyLoaded = false;

  static String _newSessionId() =>
      '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 31)}';

  static ChatMessage _welcomeMessage() => ChatMessage(
    fromUser: false,
    text: "Hello! I'm PlantBot.\nHow can I help your plants today?",
    suggestedChips: const [
      'Why are my leaves yellow?',
      'Homemade Banana Fertilizer',
      'Treat Leaf Spot',
    ],
  );

  /// Newest first (the list view is reversed). The welcome bubble is always
  /// the last (oldest) item.
  final List<ChatMessage> messages = [_welcomeMessage()];
  bool typing = false;

  /// Restores the saved conversation. Call once the user is signed in.
  /// Failures are ignored: the chat just starts empty, as before.
  Future<void> loadHistory() async {
    if (_historyLoaded) return;
    _historyLoaded = true;
    try {
      final stored = await _storage.readChatSessionId();
      final alreadyChatting = messages.any((m) => m.fromUser);
      if (stored == null || stored.isEmpty || alreadyChatting) {
        // First run (or the user already started talking): keep the current
        // session and remember it for next launch.
        await _storage.saveChatSessionId(sessionId);
        return;
      }
      sessionId = stored;
      final history = await _repo.chatHistory(stored);
      if (history.isEmpty || messages.any((m) => m.fromUser)) return;
      messages
        ..clear()
        ..addAll(history.reversed)
        ..add(_welcomeMessage());
      notifyListeners();
    } catch (_) {
      // History is a convenience; never block the chat on it.
    }
  }

  /// Forgets the current conversation (used on logout).
  void reset() {
    if (!_historyLoaded && messages.length == 1 && !typing) return;
    _historyLoaded = false;
    sessionId = _newSessionId();
    typing = false;
    messages
      ..clear()
      ..add(_welcomeMessage());
    notifyListeners();
  }
  String Function(Failure f)? errorFormatter;

  void syncWelcome({required String welcome, required List<String> chips}) {
    if (messages.length == 1 && !messages.first.fromUser) {
      if (messages.first.text != welcome) {
        messages[0] = ChatMessage(
          fromUser: false,
          text: welcome,
          suggestedChips: chips,
        );
        notifyListeners();
      }
    }
  }

  String _friendly(Failure f) {
    if (errorFormatter != null) return errorFormatter!(f);
    if (f.statusCode == 429) {
      return 'Free-tier rate limit reached. Please wait 10 seconds and try again.';
    }
    if (f.isUnauthorized) {
      return 'Please sign in with Google to chat with PlantBot.';
    }
    if (f.statusCode == null) {
      return 'I am having trouble connecting to my plant knowledge base. Please check your connection.';
    }
    return 'I had trouble with that request. Please try again!';
  }

  Future<void> send(String text, {Uint8List? imageBytes}) async {
    final t = text.trim();
    if ((t.isEmpty && imageBytes == null) || typing) return;
    messages.insert(
      0,
      ChatMessage.user(t.isEmpty ? '📷 Photo sent' : t, imageBytes: imageBytes),
    );
    typing = true;
    notifyListeners();
    try {
      final reply = imageBytes != null
          ? await _repo.analyzeImage(imageBytes)
          : await _repo.chat(sessionId, t);
      messages.insert(0, ChatMessage.bot(reply));
    } catch (e) {
      messages.insert(
        0,
        ChatMessage(fromUser: false, text: _friendly(Failure.from(e))),
      );
    }
    typing = false;
    notifyListeners();
  }
}
