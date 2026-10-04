import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/model/payment_models.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentController extends ChangeNotifier {
  PaymentController(this._repo);
  final PaymentRepository _repo;
  bool processing = false;

  /// Set by the checkout screen before navigating to payment.
  CheckoutDraft? draft;

  Future<PaymentResult> pay(
    double total,
    PaymentMethod method,
    List<OrderLine> lines,
  ) async {
    final d = draft;
    if (d == null || lines.isEmpty) {
      return const PaymentResult(
        success: false,
        error: 'Your checkout details are missing. Please go back and try again.',
      );
    }

    processing = true;
    notifyListeners();
    try {
      final result = await _repo.pay(
        total: total,
        method: method,
        order: OrderRequest(draft: d, lines: lines),
      );
      if (result.success) draft = null;
      return result;
    } catch (e) {
      return PaymentResult(success: false, error: Failure.from(e).message);
    } finally {
      processing = false;
      notifyListeners();
    }
  }
}
