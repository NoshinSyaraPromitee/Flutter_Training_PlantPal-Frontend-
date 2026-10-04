import '../model/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews(String productId);

  Future<Review> addReview(
    String productId, {
    required int rating,
    required String comment,
  });
}