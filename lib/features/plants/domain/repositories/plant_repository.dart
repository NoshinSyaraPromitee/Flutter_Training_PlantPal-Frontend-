import 'dart:typed_data';

import '../model/plant.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlants();

  Future<Plant> addPlant(NewPlant plant);

  Future<Plant> updatePlant(
    String id,
    Map<String, dynamic> changes,
  );

  Future<void> deletePlant(String id);

  Future<Plant> markWatered(String id);

  Future<Plant> markFertilized(String id);

  Future<Plant> uploadImage(
    String id,
    Uint8List imageBytes,
  );
}
