import '../model/payment_models.dart';

abstract class PaymentRepository {
  Future<PaymentResult> pay({
    required double total,
    required PaymentMethod method,
    required OrderRequest order,
  });
}
