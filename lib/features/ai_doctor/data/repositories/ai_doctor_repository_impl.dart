import 'dart:typed_data';

import 'package:plantpal/core/network/failure.dart';
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
  Future<BotReply> chat(String sessionId, String text) =>
      guardCall(() async => _chatReply(await _remote.chat(sessionId, text)));

  @override
  Future<BotReply> analyzeImage(Uint8List imageBytes, {String? plantId}) =>
      guardCall(
        () async => _diagnosisReply(
          await _remote.diagnose(imageBytes, plantId: plantId),
        ),
      );
}