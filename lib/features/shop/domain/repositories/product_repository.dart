import '../model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<List<ProductCategory>> getCategories();
}