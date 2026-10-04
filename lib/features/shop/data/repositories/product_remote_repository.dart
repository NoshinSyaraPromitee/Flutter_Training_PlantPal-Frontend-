import 'package:dio/dio.dart';
import '../../../../core/data/local_product_images.dart';
import '../../../../core/network/failure.dart';
import '../../domain/model/product.dart';
import '../../domain/repositories/product_repository.dart';

/// Talks to GET /api/v1/products on the backend catalog.
///
/// The backend doesn't track star ratings or stock counts yet, so those two
/// fields are filled with a stable placeholder derived from the product id
/// (not random on every rebuild) until the backend grows real fields for them.
class ProductRemoteRepository implements ProductRepository {
  ProductRemoteRepository(this._dio, {this.getLanguage});
  final Dio _dio;
  final String Function()? getLanguage;

  // Both getProducts() and getCategories() come from the same response, so
  // one request feeds both and a second call within the same load() doesn't
  // hit the network again.
  List<Product>? _products;
  List<ProductCategory>? _categories;
  String? _cachedLanguage;

  void invalidateCache() {
    _products = null;
    _categories = null;
    _cachedLanguage = null;
  }

  Future<void> _load() async {
    final currentLang = getLanguage?.call() ?? 'en';
    if (_cachedLanguage != null && _cachedLanguage != currentLang) {
      invalidateCache();
    }
    if (_products != null && _categories != null) return;
    _cachedLanguage = currentLang;

    final resp = await _dio.get('/api/v1/products');
    final body = resp.data as Map<String, dynamic>;

    final categoryJson = (body['categories'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final categories = categoryJson
        .map((j) => ProductCategory(j['id'] as String, j['name'] as String))
        .toList();
    final nameById = {for (final c in categories) c.id: c.name};

    final productJson = (body['products'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final products = productJson.map((j) {
      final id = j['id'] as String;
      return Product(
        id: id,
        name: j['name'] as String,
        category: nameById[j['categoryId']] ?? (j['categoryId'] as String? ?? ''),
        price: (j['priceBdt'] as num).toDouble(),
        rating: _placeholderRating(id),
        stock: _placeholderStock(id),
        description: j['description'] as String? ?? '',
        // Bundled asset takes priority over the vendor-hosted URL: the
        // backend's remote imageUrl values (Daraz/Ongkoor/etc CDNs) aren't
        // reliably renderable by Image.network on-device, so any product we
        // shipped a local photo for uses that instead. Falls back to the
        // remote URL for products added to the catalog without one yet.
        imageUrl:
            localProductImagePaths[id] ?? (j['imageUrl'] as String? ?? ''),
      );
    }).toList();

    _categories = categories;
    _products = products;
  }

  @override
  Future<List<Product>> getProducts() => guardCall(() async {
        await _load();
        return _products!;
      });

  @override
  Future<List<ProductCategory>> getCategories() => guardCall(() async {
        await _load();
        return _categories!;
      });

  // 4.5–4.9, stable per product id.
  double _placeholderRating(String id) => 4.5 + (id.hashCode.abs() % 5) / 10;

  // 12–72, stable per product id.
  int _placeholderStock(String id) => 12 + (id.hashCode.abs() % 61);
}
