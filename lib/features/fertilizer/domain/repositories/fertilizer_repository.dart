import '../model/fertilizer.dart';

abstract class FertilizerRepository {
  Future<FertilizerCatalog> getCatalog();

  Future<Fertilizer> create({
    required String name,
    required String nutrient,
    required String instructions,
  });
}
