import 'package:dio/dio.dart';

import '../../../core/network/failure.dart';
import '../domain/model/order_models.dart';

/// GET /api/v1/orders: the signed-in user's order history, newest first.
class OrderRepository {
  const OrderRepository(this._dio);
  final Dio _dio;

  Future<List<Order>> getOrders() => guardCall(() async {
        final resp = await _dio.get('/api/v1/orders');
        return (resp.data as List)
            .cast<Map<String, dynamic>>()
            .map(Order.fromJson)
            .toList();
      });
}
