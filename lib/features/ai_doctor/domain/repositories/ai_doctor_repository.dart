import 'dart:typed_data';

import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';

abstract class AiDoctorRepository {
  Future<BotReply> chat(String sessionId, String text);
  Future<BotReply> analyzeImage(Uint8List imageBytes, {String? plantId});

  /// Saved messages of one chat session, oldest first.
  Future<List<ChatMessage>> chatHistory(String sessionId);

  /// Saved scans, newest first; only those of [plantId] when given.
  Future<List<Diagnosis>> diagnosisHistory({String? plantId});
}