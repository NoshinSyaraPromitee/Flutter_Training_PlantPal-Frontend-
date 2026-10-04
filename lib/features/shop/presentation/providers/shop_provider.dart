import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/model/product.dart';
import '../../domain/repositories/product_repository.dart';

class ShopController extends ChangeNotifier {
  ShopController(this._repo);
  final ProductRepository _repo;

  List<Product> products = const [];
  List<ProductCategory> categories = const [];
  String category = 'All';
  String query = '';
  bool loading = true;
  String? error;

  bool _inFlight = false;

  /// True while a request is running (prevents duplicate loads).
  bool get isFetching => _inFlight;

  List<Product> get filtered {
    final q = query.toLowerCase().trim();
    return products
        .where((p) =>
            (category == 'All' || p.category == category) &&
            p.name.toLowerCase().contains(q))
        .toList();
  }

  Product? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// GET /api/v1/products. Needs a signed-in user, so it is called after
  /// login (see app.dart) and again by the shop screen if nothing is loaded.
  Future<void> load() async {
    if (_inFlight) return;
    _inFlight = true;
    loading = true;
    error = null;
    notifyListeners();
    try {
      products = await _repo.getProducts();
      categories = await _repo.getCategories();
      // Category names change with the language; don't keep a stale one.
      if (category != 'All' && !categories.any((c) => c.name == category)) {
        category = 'All';
      }
    } catch (e) {
      error = Failure.from(e).message;
    }
    _inFlight = false;
    loading = false;
    notifyListeners();
  }

  /// Called on logout.
  void clear() {
    products = const [];
    categories = const [];
    category = 'All';
    query = '';
    loading = true;
    error = null;
    notifyListeners();
  }

  void selectCategory(String c) {
    category = c;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }
}