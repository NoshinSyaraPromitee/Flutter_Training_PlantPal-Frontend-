import 'dart:async';
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
  /// conversation. The active id is persisted (see [loadHistory]) so the
  /// conversation survives app restarts, and dropped on logout ([reset]).
  String sessionId;
  bool _historyLoaded = false;

  static const _welcomeId = 'welcome';
  String _welcomeText = "Hello! I'm PlantBot.\nHow can I help your plants today?";
  List<String> _welcomeChips = const [
    'Why are my leaves yellow?',
    'Homemade Banana Fertilizer',
    'Treat Leaf Spot',
  ];

  static String _newSessionId() =>
      '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 31)}';

  ChatMessage _welcomeMessage() => ChatMessage(
    id: _welcomeId,
    fromUser: false,
    text: _welcomeText,
    suggestedChips: _welcomeChips,
  );

  /// Newest first (the list view is reversed). The welcome bubble is always
  /// the last (oldest) item.
  late final List<ChatMessage> messages = [_welcomeMessage()];

  /// Waiting for the first piece of a reply (or an image analysis).
  bool typing = false;

  /// A reply is arriving piece by piece.
  bool streaming = false;

  bool get busy => typing || streaming;

  /// A streamed reply is in flight and can be cancelled.
  bool get canStop => _active != null;
  bool get hasConversation => messages.any((m) => m.fromUser);

  /// True while a saved conversation is being opened.
  bool historyLoading = false;

  /// Opening a saved conversation failed (a retry banner is shown).
  bool historyFailed = false;

  // ---- "Ask AI Doctor" ----------------------------------------------------

  /// A scan the next message is about; shown as a chip above the input.
  ChatSeed? seed;

  /// Editable text to put in the input once ("My plant shows ..."). The
  /// input calls [consumePrefill] after applying it; [prefillVersion]
  /// distinguishes two pre-fills with identical text.
  String? prefill;
  int prefillVersion = 0;

  /// Starts a fresh conversation about [scan]: its photo and issue appear as
  /// a context chip above the input and [prefill] is placed in the input for
  /// the user to edit. Nothing is sent; the next send carries the scan's id.
  Future<void> startFromScan(ChatSeed scan, {required String prefill}) async {
    await newChat();
    seed = scan;
    this.prefill = prefill;
    prefillVersion++;
    _notifyNow();
  }

  /// Starts a fresh conversation about a plant in the garden: its photo and
  /// info appear as a context chip above the input, and an editable care question
  /// is placed in the input. Nothing is sent until the user submits.
  Future<void> startFromPlant(ChatSeed plantSeed, {required String prefill}) async {
    await newChat();
    seed = plantSeed;
    this.prefill = prefill;
    prefillVersion++;
    _notifyNow();
  }

  /// Removes the context chip; the next message goes out without the scan.
  void clearSeed() {
    if (seed == null) return;
    seed = null;
    notifyListeners();
  }

  /// Called by the input once it has shown [prefill], so it is applied once.
  void consumePrefill() => prefill = null;

  // ---- sessions menu ------------------------------------------------------

  List<ChatSession> sessions = const [];
  bool sessionsLoading = false;
  String? sessionsError;

  // Bumped whenever the visible conversation changes (new chat, open, reset),
  // so an in-flight reply or history load for the old one can tell it is
  // stale and must not touch the screen.
  int _gen = 0;

  ChatStream? _active;
  bool _stoppedByUser = false;
  Timer? _notifyTimer;

  String Function(Failure f)? errorFormatter;

  @override
  void dispose() {
    _notifyTimer?.cancel();
    super.dispose();
  }

  // Streamed text arrives many times a second; repaint at most every 40 ms.
  void _scheduleNotify() {
    if (_notifyTimer != null) return;
    _notifyTimer = Timer(const Duration(milliseconds: 40), () {
      _notifyTimer = null;
      notifyListeners();
    });
  }

  void _notifyNow() {
    _notifyTimer?.cancel();
    _notifyTimer = null;
    notifyListeners();
  }

  /// Restores the saved conversation. Call once the user is signed in.
  /// Failures are ignored: the chat just starts empty.
  Future<void> loadHistory() async {
    if (_historyLoaded) return;
    _historyLoaded = true;
    try {
      final stored = await _storage.readChatSessionId();
      if (stored == null || stored.isEmpty || hasConversation) {
        // First run (or the user already started talking): keep the current
        // session and remember it for next launch.
        await _storage.saveChatSessionId(sessionId);
        return;
      }
      await openSession(stored);
    } catch (_) {
      // History is a convenience; never block the chat on it.
    }
  }

  /// Forgets everything (used on logout).
  void reset() {
    _stopActive();
    _gen++;
    _historyLoaded = false;
    sessionId = _newSessionId();
    typing = false;
    streaming = false;
    historyLoading = false;
    historyFailed = false;
    seed = null;
    prefill = null;
    sessions = const [];
    sessionsError = null;
    messages
      ..clear()
      ..add(_welcomeMessage());
    _storage.clearChatSessionId();
    _notifyNow();
  }

  void syncWelcome({required String welcome, required List<String> chips}) {
    _welcomeText = welcome;
    _welcomeChips = chips;
    final last = messages.isEmpty ? null : messages.last;
    if (last != null && last.id == _welcomeId && last.text != welcome) {
      messages[messages.length - 1] = _welcomeMessage();
      notifyListeners();
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

  // ---- sessions -----------------------------------------------------------

  Future<void> loadSessions() async {
    sessionsLoading = true;
    sessionsError = null;
    notifyListeners();
    try {
      sessions = await _repo.chatSessions();
    } catch (e) {
      sessionsError = Failure.from(e).message;
    }
    sessionsLoading = false;
    notifyListeners();
  }

  /// Starts a fresh conversation. Does nothing when the current one is
  /// already empty.
  Future<void> newChat() async {
    final hadSeed = seed != null;
    seed = null;
    prefill = null;
    if (!hasConversation && !busy && !historyLoading && !historyFailed) {
      if (hadSeed) notifyListeners();
      return;
    }
    _stopActive();
    _gen++;
    sessionId = _newSessionId();
    typing = false;
    streaming = false;
    historyLoading = false;
    historyFailed = false;
    messages
      ..clear()
      ..add(_welcomeMessage());
    _notifyNow();
    await _storage.saveChatSessionId(sessionId);
  }

  /// Switches to a saved conversation and loads its messages.
  Future<void> openSession(String id, {bool force = false}) async {
    if (!force && id == sessionId && hasConversation && !historyFailed) return;
    _stopActive();
    final gen = ++_gen;
    sessionId = id;
    seed = null;
    prefill = null;
    typing = false;
    streaming = false;
    historyLoading = true;
    historyFailed = false;
    messages
      ..clear()
      ..add(_welcomeMessage());
    _notifyNow();
    await _storage.saveChatSessionId(id);

    try {
      final history = await _repo.chatHistory(id);
      if (gen != _gen) return;
      messages
        ..clear()
        ..addAll(history.reversed)
        ..add(_welcomeMessage());
    } catch (_) {
      if (gen != _gen) return;
      historyFailed = true;
    }
    historyLoading = false;
    _notifyNow();
  }

  /// Deletes a saved conversation. Returns false if it could not be deleted.
  Future<bool> deleteSession(String id) async {
    try {
      await _repo.deleteChatSession(id);
    } catch (e) {
      // Already gone (404) counts as deleted.
      if (Failure.from(e).statusCode != 404) return false;
    }
    sessions = [for (final s in sessions) if (s.id != id) s];
    if (id == sessionId) {
      await newChat();
    } else {
      notifyListeners();
    }
    return true;
  }

  // ---- sending ------------------------------------------------------------

  Future<void> send(String text, {Uint8List? imageBytes}) async {
    final t = text.trim();
    if ((t.isEmpty && imageBytes == null) || busy) return;
    if (imageBytes != null) return _sendImage(t, imageBytes);
    return _sendStreaming(t);
  }

  /// Stops the reply that is being generated. The part already received
  /// stays in the conversation (the server keeps it too).
  void stop() => _stopActive();

  void _stopActive() {
    final active = _active;
    if (active == null) return;
    _stoppedByUser = true;
    _active = null;
    active.cancel();
  }

  /// Sends a photo (with the typed text as its caption). The server saves
  /// the scan once and, because [sessionId] is sent, also records the photo
  /// turn and a short summary in this chat session, so history shows them
  /// and follow-up questions remember the scan.
  Future<void> _sendImage(String caption, Uint8List imageBytes) async {
    seed = null; // a new photo replaces any scan context
    prefill = null;
    final sent = ChatMessage.user(caption, imageBytes: imageBytes);
    messages.insert(0, sent);
    typing = true;
    notifyListeners();
    final gen = _gen;
    try {
      final reply = await _repo.analyzeImage(
        imageBytes,
        sessionId: sessionId,
        note: caption.isEmpty ? null : caption,
      );
      if (gen != _gen) return;
      // Remember which scan the bubble belongs to (it keeps its local bytes).
      final scan = reply.diagnosis;
      final i = messages.indexWhere((m) => m.id == sent.id);
      if (i >= 0 && scan?.id != null) {
        messages[i] = messages[i].copyWith(
          diagnosisId: scan!.id,
          imageUrl: scan.imageUrl,
        );
      }
      messages.insert(0, ChatMessage.bot(reply));
    } catch (e) {
      if (gen != _gen) return;
      messages.insert(
        0,
        ChatMessage(fromUser: false, text: _friendly(Failure.from(e))),
      );
    }
    typing = false;
    notifyListeners();
  }

  Future<void> _sendStreaming(String text) async {
    final gen = _gen;
    // A pending scan ("Ask AI Doctor") rides along with this message.
    final scan = seed;
    seed = null;
    prefill = null;
    messages.insert(
      0,
      ChatMessage(
        fromUser: true,
        text: text,
        imageBytes: scan?.imageBytes,
        diagnosisId: scan?.diagnosisId,
        imageUrl: scan?.imageUrl,
      ),
    );
    typing = true;
    _stoppedByUser = false;
    notifyListeners();

    final stream = _repo.chatStream(
      sessionId,
      text,
      diagnosisId: scan?.diagnosisId,
    );
    _active = stream;

    String? botId;
    var buffer = '';
    var gotDone = false;
    Failure? failure;

    int botIndex() => messages.indexWhere((m) => m.id == botId);

    try {
      await for (final event in stream.events) {
        if (gen != _gen) return; // conversation switched; ignore the rest
        switch (event) {
          case ChatStreamStart(:final assistantId):
            botId = assistantId.isEmpty ? null : assistantId;
          case ChatStreamDelta(text: final piece):
            buffer += piece;
            if (botIndex() < 0) {
              botId ??= 'stream-${DateTime.now().microsecondsSinceEpoch}';
              messages.insert(
                0,
                ChatMessage(
                  id: botId,
                  fromUser: false,
                  text: buffer,
                  isStreaming: true,
                ),
              );
              typing = false;
              streaming = true;
              _notifyNow(); // show the first words immediately
            } else {
              messages[botIndex()] = messages[botIndex()].copyWith(text: buffer);
              _scheduleNotify();
            }
          case ChatStreamDone(text: final doneText, :final provider):
            gotDone = true;
            final i = botIndex();
            if (i >= 0) {
              messages[i] = messages[i].copyWith(
                text: doneText.isEmpty ? buffer : doneText,
                provider: provider,
                isStreaming: false,
              );
            }
          case ChatStreamError(:final code, :final message):
            failure = Failure(
              message,
              statusCode: code == 'rate_limited' ? 429 : 500,
            );
        }
      }
    } catch (e) {
      failure = Failure.from(e);
    }

    if (gen != _gen) return; // reset/new chat/open already cleaned up

    // The stream ended: freeze the bubble, whatever the reason.
    final i = botIndex();
    if (i >= 0 && messages[i].isStreaming) {
      messages[i] = messages[i].copyWith(isStreaming: false);
    }
    if (failure == null && !gotDone && !_stoppedByUser) {
      // Connection dropped without a clean ending.
      failure = const Failure('stream ended unexpectedly');
    }
    if (failure != null && !_stoppedByUser) {
      messages.insert(
        0,
        ChatMessage(fromUser: false, text: _friendly(failure)),
      );
    }

    _active = null;
    typing = false;
    streaming = false;
    _notifyNow();
  }
}
