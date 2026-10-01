import '../model/fertilizer.dart';

abstract class FertilizerRepository {
  Future<FertilizerCatalog> getCatalog();
}

