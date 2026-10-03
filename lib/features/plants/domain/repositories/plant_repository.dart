import 'dart:typed_data';

import '../model/plant.dart';
import '../model/plant_event.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlants();

  Future<Plant> addPlant(NewPlant plant);

  Future<Plant> updatePlant(String id, Map<String, dynamic> changes);

  Future<void> deletePlant(String id);

  Future<PlantActionResult> markWatered(String id);

  Future<PlantActionResult> markFertilized(String id);

  Future<List<PlantEvent>> getEvents({String? plantId});

  Future<Plant> skipWatering(
    String id, {
    required String reason,
    required int days,
  });

  Future<void> addNote(String id, String note);

  Future<Plant> uploadImage(String id, Uint8List imageBytes);

  Future<PlantIdentification> identifyPlant(Uint8List imageBytes);
}
