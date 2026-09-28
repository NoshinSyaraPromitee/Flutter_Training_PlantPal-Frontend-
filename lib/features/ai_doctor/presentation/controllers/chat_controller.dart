import 'dart:math';

import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/entities/chat_models.dart';
import '../../domain/repositories/ai_doctor_repository.dart';

class ChatController extends ChangeNotifier {
  ChatController(this._repo)
    : sessionId =
          '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 31)}';
  final AiDoctorRepository _repo;

  /// One session per controller instance (i.e. per app run) — sent with
  /// every chat message so the backend can keep history per conversation.
  final String sessionId;

  /// Newest first (the list view is reversed).
  final List<ChatMessage> messages = [
    ChatMessage(
      fromUser: false,
      text: "Hello! I'm PlantBot.\nHow can I help your plants today?",
      suggestedChips: const [
        'Why are my leaves yellow?',
        'Homemade Banana Fertilizer',
        'Treat Leaf Spot',
      ],
    ),
  ];
  bool typing = false;
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
