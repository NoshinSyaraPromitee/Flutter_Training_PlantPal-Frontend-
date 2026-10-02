import 'dart:convert';
import 'dart:typed_data';

import 'package:plantpal/core/network/api_client.dart';
import 'package:plantpal/core/network/sse_client.dart';

class AiDoctorRemoteDataSource {
  AiDoctorRemoteDataSource(this._api);
  final ApiClient _api;

  /// Posts a chat message and returns the assistant's [Message] (the backend
  /// replies with both the user and assistant turns; we only need the latter).
  Future<Map<String, dynamic>> chat(
    String sessionId,
    String text, {
    String? diagnosisId,
  }) async {
    final res = await _api.dio.post(
      '/api/v1/chat/messages',
      data: {
        'sessionId': sessionId,
        'content': text,
        'diagnosisId': ?diagnosisId,
      },
    );
    final messages = _asList(_unwrap(res.data));
    return messages.firstWhere(
      (m) => m['role'] == 'assistant',
      orElse: () => messages.last,
    );
  }

  /// GET /chat/messages?sessionId= — the saved turns of one conversation.
  Future<List<Map<String, dynamic>>> chatHistory(String sessionId) async {
    final res = await _api.dio.get(
      '/api/v1/chat/messages',
      queryParameters: {'sessionId': sessionId},
    );
    return _asList(_unwrap(res.data));
  }

  /// POST /chat/messages/stream — the reply arrives as Server-Sent Events
  /// (start, delta..., done | error). See [SseConnection].
  Future<SseConnection> chatStream(
    String sessionId,
    String text, {
    String? diagnosisId,
  }) =>
      _api.openSse('/api/v1/chat/messages/stream', {
        'sessionId': sessionId,
        'content': text,
        'diagnosisId': ?diagnosisId,
      });

  /// GET /chat/sessions — the user's conversations, most recent first.
  Future<List<Map<String, dynamic>>> chatSessions() async {
    final res = await _api.dio.get('/api/v1/chat/sessions');
    return _asList(_unwrap(res.data));
  }

  /// DELETE /chat/sessions/{id}
  Future<void> deleteChatSession(String id) async {
    await _api.dio.delete('/api/v1/chat/sessions/${Uri.encodeComponent(id)}');
  }

  // The backend wraps JSON bodies as {"data": ...}; accept both that and a
  // bare body.
  Object? _unwrap(Object? body) =>
      body is Map && body.containsKey('data') ? body['data'] : body;

  /// GET /diagnoses[?plantId=] — saved scans for the signed-in user.
  Future<List<Map<String, dynamic>>> diagnoses({String? plantId}) async {
    final res = await _api.dio.get(
      '/api/v1/diagnoses',
      queryParameters: {'plantId': ?plantId},
    );
    return _asList(_unwrap(res.data));
  }

  // The backend answers an empty result as `"data": null`, so treat anything
  // that isn't a list as "no items" instead of throwing.
  List<Map<String, dynamic>> _asList(Object? data) =>
      data is List ? data.cast<Map<String, dynamic>>() : const [];

  /// Submits a plant photo for diagnosis. The backend takes the image as
  /// base64 JSON, not multipart.
  ///
  /// With [sessionId] the server also records the scan in that chat session
  /// (the photo + [note] as the user's turn, a short summary as the reply),
  /// so reopening the chat shows it and later questions remember it. [note]
  /// is the user's caption, passed to the model as a hint.
  Future<Map<String, dynamic>> diagnose(
    Uint8List imageBytes, {
    String? plantId,
    String? sessionId,
    String? note,
  }) async {
    final res = await _api.dio.post(
      '/api/v1/diagnoses',
      data: {
        'plantId': plantId,
        'imageBase64': base64Encode(imageBytes),
        'sessionId': ?sessionId,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      },
    );
    return _unwrap(res.data) as Map<String, dynamic>;
  }
}