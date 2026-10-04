import 'package:dio/dio.dart';

import '../../../../core/network/failure.dart';
import '../../domain/model/payment_models.dart';
import '../../domain/repositories/payment_repository.dart';

/// Creates the order via POST /api/v1/orders.
///
/// The backend has no payment gateway yet: any valid order is recorded as
/// "processing". The total is recomputed server-side (subtotal + delivery
/// fee + 5% tax), so [total] is only used for display in the app.
class RemotePaymentRepository implements PaymentRepository {
  RemotePaymentRepository(this._dio);
  final Dio _dio;

  @override
  Future<PaymentResult> pay({
    required double total,
    required PaymentMethod method,
    required OrderRequest order,
  }) async {
    try {
      final resp = await _dio.post(
        '/api/v1/orders',
        data: order.toJson(method.id),
      );
      final body = resp.data as Map<String, dynamic>;
      return PaymentResult(
        success: true,
        orderId: (body['id'] ?? '').toString(),
      );
    } catch (e) {
      return PaymentResult(success: false, error: Failure.from(e).message);
    }
  }
}
