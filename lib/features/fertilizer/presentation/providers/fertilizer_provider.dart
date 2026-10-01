import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/model/fertilizer.dart';
import '../../domain/repositories/fertilizer_repository.dart';

class FertilizerController extends ChangeNotifier {
  FertilizerController(this._repo);
  final FertilizerRepository _repo;

  FertilizerCatalog catalog = const FertilizerCatalog(items: [], safetyTips: []);
  String query = '';
  bool loading = true;
  String? error;

  List<Fertilizer> get filtered =>
      catalog.items.where((f) => f.matches(query)).toList();

  Fertilizer? byId(String id) {
    for (final f in catalog.items) {
      if (f.id == id) return f;
    }
    return null;
  }

  /// GET /api/v1/fertilizers. Needs a signed-in user, so it is called after
  /// login (see app.dart).
  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      catalog = await _repo.getCatalog();
    } catch (e) {
      error = Failure.from(e).message;
    }
    loading = false;
    notifyListeners();
  }

  /// POST /api/v1/fertilizers. Returns an error message, or null on success.
  Future<String?> add({
    required String name,
    required String nutrient,
    required String instructions,
  }) async {
    try {
      final created = await _repo.create(
        name: name,
        nutrient: nutrient,
        instructions: instructions,
      );
      catalog = FertilizerCatalog(
        items: [created, ...catalog.items],
        safetyTips: catalog.safetyTips,
      );
      notifyListeners();
      return null;
    } catch (e) {
      return Failure.from(e).message;
    }
  }

  /// Called on logout.
  void clear() {
    catalog = const FertilizerCatalog(items: [], safetyTips: []);
    query = '';
    loading = true;
    error = null;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }
}
