import 'package:dio/dio.dart';

import '../../../../core/network/failure.dart';
import '../../domain/model/fertilizer.dart';
import '../../domain/repositories/fertilizer_repository.dart';
import '../models/fertilizer_model.dart';
import 'fertilizer_local_repository.dart';

/// GET/POST /api/v1/fertilizers. The backend localizes name, category and
/// instructions from the Accept-Language header (set in ApiClient).
class FertilizerRemoteRepository implements FertilizerRepository {
  FertilizerRemoteRepository(this._dio, {this.getLanguage});

  final Dio _dio;
  final String Function()? getLanguage;

  @override
  Future<FertilizerCatalog> getCatalog() => guardCall(() async {
        final resp = await _dio.get('/api/v1/fertilizers');
        final items = (resp.data as List)
            .cast<Map<String, dynamic>>()
            .map(FertilizerModel.fromJson)
            .toList();

        // The backend has no safety tips; keep the bundled ones.
        final tips = (await FertilizerLocalRepository(getLanguage: getLanguage)
                .getCatalog())
            .safetyTips;

        return FertilizerCatalog(items: items, safetyTips: tips);
      });

  @override
  Future<Fertilizer> create({
    required String name,
    required String nutrient,
    required String instructions,
  }) =>
      guardCall(() async {
        final resp = await _dio.post(
          '/api/v1/fertilizers',
          data: {
            'name': name,
            'category': nutrient,
            'instructions': instructions,
          },
        );
        return FertilizerModel.fromJson(resp.data as Map<String, dynamic>);
      });
}
