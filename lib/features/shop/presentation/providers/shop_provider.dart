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

  List<Product> get filtered {
    final q = query.toLowerCase().trim();
    return products.where((p) => (category == 'All' || p.category == category) && p.name.toLowerCase().contains(q)).toList();
  }

  Product? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> load() async {
    try {
      products = await _repo.getProducts();
      categories = await _repo.getCategories();
    } catch (e) {
      error = Failure.from(e).message;
    }
    loading = false;
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