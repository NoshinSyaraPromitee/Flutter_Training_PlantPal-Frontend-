import 'package:flutter/foundation.dart';
import '../../domain/model/review.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewsController extends ChangeNotifier {
  ReviewsController(this._repo);
  final ReviewRepository _repo;
  final Map<String, List<Review>> _by = {};

  List<Review> of(String productId) => _by[productId] ?? const [];

  double? average(String productId) {
    final l = of(productId);
    if (l.isEmpty) return null;
    return l.fold<int>(0, (s, r) => s + r.rating) / l.length;
  }

  Future<void> load(String productId) async {
    if (_by.containsKey(productId)) return;
    _by[productId] = await _repo.getReviews(productId);
    notifyListeners();
  }

  Future<void> add(String productId, {required int rating, required String comment}) async {
    final r = await _repo.addReview(productId, rating: rating, comment: comment);
    _by[productId] = [r, ...of(productId)];
    notifyListeners();
  }
}