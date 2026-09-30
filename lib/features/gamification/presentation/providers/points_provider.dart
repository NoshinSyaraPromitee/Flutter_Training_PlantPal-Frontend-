import 'package:flutter/foundation.dart';

/// Loyalty points wallet. Conversion: 10 points = ৳0.01 (1 point = ৳0.001).
class PointsController extends ChangeNotifier {
  // TODO: load real balance from the gamification/rewards backend.
  int _balance = 999;

  int get balance => _balance;

  static const int pointsPerTaka = 1000; // 1000 points = ৳1
  static const double _takaPerPoint = 1 / pointsPerTaka;

  double takaValue(int points) => points * _takaPerPoint;

  /// Max points usable against [orderTotal] — capped by wallet balance and
  /// by the order total itself (can't redeem past ৳0 due).
  int maxRedeemablePoints(double orderTotal) {
    final capByTotal = (orderTotal / _takaPerPoint).floor();
    return _balance < capByTotal ? _balance : capByTotal;
  }

  void redeem(int points) {
    if (points <= 0) return;
    _balance = (_balance - points).clamp(0, _balance);
    notifyListeners();
  }

  /// Awards points for a completed care action (e.g. watering a plant).
  void add(int points) {
    if (points <= 0) return;
    _balance += points;
    notifyListeners();
  }
}