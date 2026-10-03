import 'package:flutter/foundation.dart';
import '../../../shop/domain/model/product.dart';

class WishlistController extends ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => List.unmodifiable(_items);

  bool contains(String id) => _items.any((p) => p.id == id);

  void toggle(Product p) {
    if (contains(p.id)) {
      _items.removeWhere((x) => x.id == p.id);
    } else {
      _items.add(p);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}