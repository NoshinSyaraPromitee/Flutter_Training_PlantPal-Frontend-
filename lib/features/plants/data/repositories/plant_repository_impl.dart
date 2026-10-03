import 'dart:typed_data';

import '../../../../core/network/failure.dart';
import '../../domain/model/plant.dart';
import '../../domain/model/plant_event.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_data_source.dart';
import '../models/plant_model.dart';

class PlantRepositoryImpl implements PlantRepository {
  PlantRepositoryImpl(this._remote);

  final PlantRemoteDataSource _remote;

  @override
  Future<List<Plant>> getPlants() => guardCall(
    () async => (await _remote.fetchAll()).map(PlantModel.fromJson).toList(),
  );

  @override
  Future<Plant> addPlant(NewPlant plant) => guardCall(
    () async =>
        PlantModel.fromJson(await _remote.create(PlantModel.newToJson(plant))),
  );

  @override
  Future<Plant> updatePlant(String id, Map<String, dynamic> changes) =>
      guardCall(
        () async => PlantModel.fromJson(await _remote.patch(id, changes)),
      );

  @override
  Future<void> deletePlant(String id) => guardCall(() => _remote.remove(id));

  @override
  Future<PlantActionResult> markWatered(String id) => guardCall(() async {
    final json = await _remote.water(id);
    return PlantActionResult(
      plant: PlantModel.fromJson(json['plant'] as Map<String, dynamic>),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
    );
  });

  @override
  Future<PlantActionResult> markFertilized(String id) => guardCall(() async {
    final json = await _remote.fertilize(id);
    return PlantActionResult(
      plant: PlantModel.fromJson(json['plant'] as Map<String, dynamic>),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
    );
  });

  @override
  Future<List<PlantEvent>> getEvents({String? plantId}) => guardCall(
    () async =>
        (await _remote.events(plantId: plantId))
            .map(PlantEvent.fromJson)
            .toList(),
  );

  @override
  Future<Plant> skipWatering(
    String id, {
    required String reason,
    required int days,
  }) => guardCall(
    () async =>
        PlantModel.fromJson(await _remote.skip(id, reason: reason, days: days)),
  );

  @override
  Future<void> addNote(String id, String note) =>
      guardCall(() => _remote.addNote(id, note));

  @override
  Future<Plant> uploadImage(String id, Uint8List imageBytes) => guardCall(
    () async => PlantModel.fromJson(await _remote.uploadImage(id, imageBytes)),
  );

  @override
  Future<PlantIdentification> identifyPlant(Uint8List imageBytes) => guardCall(
    () async =>
        PlantIdentification.fromJson(await _remote.identify(imageBytes)),
  );
}
