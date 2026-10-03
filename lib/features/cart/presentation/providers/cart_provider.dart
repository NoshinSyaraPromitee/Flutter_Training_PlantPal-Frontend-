import 'package:flutter/foundation.dart';
import '../../domain/model/cart_item.dart';
import '../../../shop/domain/model/product.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get subtotal => _items.fold<double>(0, (s, i) => s + i.lineTotal);

  int _index(String id) => _items.indexWhere((i) => i.product.id == id);

  void add(Product p, {int quantity = 1}) {
    final i = _index(p.id);
    if (i >= 0) {
      _items[i] = _items[i].copyWith(quantity: _items[i].quantity + quantity);
    } else {
      _items.add(CartItem(product: p, quantity: quantity));
    }
    notifyListeners();
  }

  void increase(String id) {
    final i = _index(id);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(quantity: _items[i].quantity + 1);
    notifyListeners();
  }

  void decrease(String id) {
    final i = _index(id);
    if (i < 0 || _items[i].quantity <= 1) return;
    _items[i] = _items[i].copyWith(quantity: _items[i].quantity - 1);
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((i) => i.product.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}