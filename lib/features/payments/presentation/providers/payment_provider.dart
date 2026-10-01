import 'package:flutter/foundation.dart';
import '../../domain/model/payment_models.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentController extends ChangeNotifier {
  PaymentController(this._repo);
  final PaymentRepository _repo;
  bool processing = false;

  Future<PaymentResult> pay(double total, PaymentMethod method) async {
    processing = true;
    notifyListeners();
    try {
      return await _repo.pay(total: total, method: method);
    } catch (_) {
      return const PaymentResult(success: false);
    } finally {
      processing = false;
      notifyListeners();
    }
  }
}