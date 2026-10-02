import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/core/network/sse_client.dart';
import 'package:plantpal/features/ai_doctor/data/datasources/ai_doctor_remote_data_source.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/features/ai_doctor/domain/repositories/ai_doctor_repository.dart';

class AiDoctorRepositoryImpl implements AiDoctorRepository {
  AiDoctorRepositoryImpl(this._remote);
  final AiDoctorRemoteDataSource _remote;

  BotReply _chatReply(Map<String, dynamic> j) => BotReply(
        text: j['content']?.toString() ?? '',
        provider: j['provider']?.toString(),
      );

  Diagnosis _diagnosis(Map<String, dynamic> j) => Diagnosis(
        issue: j['issue']?.toString() ?? 'Unknown',
        cure: j['cure']?.toString() ?? '',
        disclaimer: j['disclaimer']?.toString() ?? '',
        provider: j['provider']?.toString(),
        id: j['id']?.toString(),
        plantId: j['plantId']?.toString(),
        createdAt: _date(j['createdAt']),
        imageUrl: j['imageUrl']?.toString(),
      );

  BotReply _diagnosisReply(Map<String, dynamic> j) =>
      BotReply(text: '', diagnosis: _diagnosis(j));

  DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v)?.toLocal() : null;

  @override
  Future<List<ChatMessage>> chatHistory(String sessionId) =>
      guardCall(() async {
        final rows = await _remote.chatHistory(sessionId);
        rows.sort((a, b) {
          final x = _date(a['createdAt']), y = _date(b['createdAt']);
          if (x == null || y == null) return 0;
          return x.compareTo(y);
        });
        return [
          for (final j in rows)
            ChatMessage(
              id: j['id']?.toString(),
              fromUser: j['role'] == 'user',
              text: j['content']?.toString() ?? '',
              provider: j['provider']?.toString(),
              diagnosisId: j['diagnosisId']?.toString(),
              imageUrl: j['imageUrl']?.toString(),
            ),
        ];
      });

  @override
  Future<List<Diagnosis>> diagnosisHistory({String? plantId}) => guardCall(
        () async => [
          for (final j in await _remote.diagnoses(plantId: plantId))
            _diagnosis(j),
        ],
      );

  @override
  Future<BotReply> chat(String sessionId, String text, {String? diagnosisId}) =>
      guardCall(
        () async => _chatReply(
          await _remote.chat(sessionId, text, diagnosisId: diagnosisId),
        ),
      );

  @override
  Future<BotReply> analyzeImage(
    Uint8List imageBytes, {
    String? plantId,
    String? sessionId,
    String? note,
  }) =>
      guardCall(
        () async => _diagnosisReply(
          await _remote.diagnose(
            imageBytes,
            plantId: plantId,
            sessionId: sessionId,
            note: note,
          ),
        ),
      );

  @override
  Future<List<ChatSession>> chatSessions() => guardCall(() async {
        final rows = await _remote.chatSessions();
        return [
          for (final j in rows)
            if (j['id'] != null)
              ChatSession(
                id: j['id'].toString(),
                title: j['title']?.toString() ?? '',
                lastMessageAt: _date(j['lastMessageAt']) ?? DateTime.now(),
                messageCount: (j['messageCount'] as num?)?.toInt() ?? 0,
              ),
        ];
      });

  @override
  Future<void> deleteChatSession(String sessionId) =>
      guardCall(() => _remote.deleteChatSession(sessionId));

  @override
  ChatStream chatStream(String sessionId, String text, {String? diagnosisId}) {
    final out = StreamController<ChatStreamEvent>();
    SseConnection? connection;
    var cancelled = false;

    () async {
      try {
        connection = await _remote.chatStream(
          sessionId,
          text,
          diagnosisId: diagnosisId,
        );
        if (cancelled) connection!.cancel();
        await for (final e in connection!.events) {
          final event = _streamEvent(e);
          if (event != null) out.add(event);
        }
      } catch (e, st) {
        if (!cancelled) out.addError(Failure.from(e), st);
      } finally {
        await out.close();
      }
    }();

    return ChatStream(out.stream, () {
      cancelled = true;
      connection?.cancel();
    });
  }

  /// Turns one SSE event into a typed one; unknown or malformed events are
  /// skipped so a future server-side addition cannot break the chat.
  ChatStreamEvent? _streamEvent(SseEvent e) {
    try {
      final j = jsonDecode(e.data);
      if (j is! Map) return null;
      switch (e.event) {
        case 'start':
          return ChatStreamStart(j['assistantId']?.toString() ?? '');
        case 'delta':
          final text = j['text']?.toString() ?? '';
          return text.isEmpty ? null : ChatStreamDelta(text);
        case 'done':
          final m = j['message'];
          if (m is! Map) return null;
          return ChatStreamDone(
            text: m['content']?.toString() ?? '',
            provider: m['provider']?.toString(),
          );
        case 'error':
          return ChatStreamError(
            code: j['code']?.toString() ?? 'interrupted',
            message: j['error']?.toString() ?? '',
          );
      }
    } catch (_) {}
    return null;
  }
}
