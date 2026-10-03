import 'dart:typed_data';

import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';

abstract class AiDoctorRepository {
  Future<BotReply> chat(String sessionId, String text, {String? diagnosisId});

  /// Analyzes a photo. With [sessionId] the scan is also recorded in that
  /// chat session; [note] is the user's caption (a hint for the model).
  Future<BotReply> analyzeImage(
    Uint8List imageBytes, {
    String? plantId,
    String? sessionId,
    String? note,
  });

  /// Sends [text] and streams the reply as it is generated.
  ///
  /// [diagnosisId] attaches a saved scan as context for this message.
  ChatStream chatStream(String sessionId, String text, {String? diagnosisId});

  /// The user's saved conversations, most recent first.
  Future<List<ChatSession>> chatSessions();

  Future<void> deleteChatSession(String sessionId);

  /// Saved messages of one chat session, oldest first.
  Future<List<ChatMessage>> chatHistory(String sessionId);

  /// Saved scans, newest first; only those of [plantId] when given.
  Future<List<Diagnosis>> diagnosisHistory({String? plantId});

  /// POST /diagnoses/{id}/treated: the user acted on the advice.
  Future<Diagnosis> markDiagnosisTreated(String id);
}