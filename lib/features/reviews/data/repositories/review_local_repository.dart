import '../../domain/model/review.dart';
import '../../domain/repositories/review_repository.dart';

/// In-memory reviews (seeded). New reviews live until the app restarts.
class ReviewLocalRepository implements ReviewRepository {
  final Map<String, List<Review>> _store = {
    '1': [
      const Review(
        id: 'r1',
        name: 'Rafiul Hasan',
        rating: 5,
        date: '2026-06-02',
        comment:
            'Arrived healthy and well packed. Already growing new leaves!',
      ),
      const Review(
        id: 'r2',
        name: 'Sadia Islam',
        rating: 4,
        date: '2026-05-18',
        comment:
            'Good sapling, a little smaller than I expected but healthy.',
      ),
    ],
    '3': [
      const Review(
        id: 'r3',
        name: 'Tanvir Ahmed',
        rating: 5,
        date: '2026-06-10',
        comment:
            'Sturdy clay pot, no cracks, looks great on my balcony.',
      ),
    ],
    '4': [
      const Review(
        id: 'r4',
        name: 'Nusrat Jahan',
        rating: 5,
        date: '2026-06-14',
        comment:
            'My plants love this. Noticed greener leaves within two weeks.',
      ),
      const Review(
        id: 'r5',
        name: 'Imran Kabir',
        rating: 4,
        date: '2026-05-29',
        comment:
            'Works well, smell is a bit strong at first but fades quickly.',
      ),
    ],
    '6': [
      const Review(
        id: 'r6',
        name: 'Farhana Akter',
        rating: 5,
        date: '2026-06-01',
        comment:
            'Great germination rate, exactly as described.',
      ),
    ],
  };

  @override
  Future<List<Review>> getReviews(String productId) async =>
      List.of(_store[productId] ?? const []);

  @override
  Future<Review> addReview(
    String productId, {
    required int rating,
    required String comment,
  }) async {
    final review = Review(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      name: 'You',
      rating: rating,
      date: DateTime.now().toIso8601String().substring(0, 10),
      comment: comment.trim(),
    );

    _store[productId] = [
      review,
      ...(_store[productId] ?? const []),
    ];

    return review;
  }
}