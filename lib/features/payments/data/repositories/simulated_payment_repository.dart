import 'dart:math';

import '../../domain/model/payment_models.dart';
import '../../domain/repositories/payment_repository.dart';

/// Demo payment (always succeeds). Replace with a real implementation later.
class SimulatedPaymentRepository implements PaymentRepository {
  @override
  Future<PaymentResult> pay({
    required double total,
    required PaymentMethod method,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 1500),
    );

    return PaymentResult(
      success: true,
      orderId: '${100000 + Random().nextInt(900000)}',
    );
  }
}