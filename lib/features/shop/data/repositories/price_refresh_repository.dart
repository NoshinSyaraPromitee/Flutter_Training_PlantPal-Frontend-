import 'package:dio/dio.dart';
import '../../../../core/network/failure.dart';

/// The result of an AI-powered price refresh from the backend.
class PriceRefreshResult {
  const PriceRefreshResult({
    required this.productId,
    required this.priceBdt,
    required this.priceUsd,
    required this.inStock,
    required this.asOf,
    required this.source,
    this.note,
  });

  final String productId;
  final double priceBdt;
  final double priceUsd;
  final bool inStock;
  final DateTime asOf;
  final String source;
  final String? note;

  factory PriceRefreshResult.fromJson(Map<String, dynamic> j) =>
      PriceRefreshResult(
        productId: j['productId'] as String,
        priceBdt: (j['priceBdt'] as num).toDouble(),
        priceUsd: (j['priceUsd'] as num).toDouble(),
        inStock: j['inStock'] as bool? ?? true,
        asOf: DateTime.parse(j['asOf'] as String),
        source: j['source'] as String? ?? '',
        note: j['note'] as String?,
      );
}

/// Calls POST /api/v1/products/{id}/refresh on the backend.
/// The backend holds the Groq key and caches results for 6 hours.
class PriceRefreshRepository {
  const PriceRefreshRepository(this._dio);
  final Dio _dio;

  Future<PriceRefreshResult> refresh(String productId) async {
    try {
      final resp = await _dio.post('/api/v1/products/$productId/refresh');
      return PriceRefreshResult.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Failure.from(e);
    }
  }
}
