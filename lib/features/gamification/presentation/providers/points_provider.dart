import 'package:flutter/foundation.dart';

import '../../../../core/storage/secure_storage.dart';

/// Loyalty points wallet. Conversion: 1000 points = 1 taka.
///
/// The backend has no points/coins endpoint yet, so the balance is kept
/// on the device. When that endpoint exists, swap [load] and [_save]
/// for API calls; nothing else in the app needs to change.
class PointsController extends ChangeNotifier {
  PointsController(this._storage);

  final SecureStorage _storage;

  static const _balanceKey = 'points_balance';

  int _balance = 0;

  int get balance => _balance;

  static const int pointsPerTaka = 1000; // 1000 points = 1 taka
  static const double _takaPerPoint = 1 / pointsPerTaka;

  double takaValue(int points) => points * _takaPerPoint;

  Future<void> load() async {
    try {
      final saved = int.tryParse(await _storage.read(_balanceKey) ?? '');
      if (saved != null) {
        _balance = saved;
        notifyListeners();
      }
    } catch (_) {
      // Keep the in-memory balance if storage is unavailable.
    }
  }

  Future<void> _save() async {
    try {
      await _storage.write(_balanceKey, _balance.toString());
    } catch (_) {}
  }

  /// Max points usable against [orderTotal], capped by wallet balance and
  /// by the order total itself (can't redeem past 0 due).
  int maxRedeemablePoints(double orderTotal) {
    final capByTotal = (orderTotal / _takaPerPoint).floor();
    return _balance < capByTotal ? _balance : capByTotal;
  }

  void redeem(int points) {
    if (points <= 0) return;
    _balance = (_balance - points).clamp(0, _balance);
    notifyListeners();
    _save();
  }

  /// Awards points for a completed care action (e.g. watering a plant).
  void add(int points) {
    if (points <= 0) return;
    _balance += points;
    notifyListeners();
    _save();
  }
}
