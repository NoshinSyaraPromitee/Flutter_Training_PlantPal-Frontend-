import 'dart:typed_data';

import '../../../../core/network/failure.dart';
import '../../domain/model/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_remote_data_source.dart';
import '../models/plant_model.dart';

class PlantRepositoryImpl implements PlantRepository {
  PlantRepositoryImpl(this._remote);

  final PlantRemoteDataSource _remote;

  @override
  Future<List<Plant>> getPlants() => guardCall(
        () async => (await _remote.fetchAll())
            .map(PlantModel.fromJson)
            .toList(),
      );

  @override
  Future<Plant> addPlant(NewPlant plant) => guardCall(
        () async => PlantModel.fromJson(
          await _remote.create(PlantModel.newToJson(plant)),
        ),
      );

  @override
  Future<Plant> updatePlant(
    String id,
    Map<String, dynamic> changes,
  ) =>
      guardCall(
        () async => PlantModel.fromJson(
          await _remote.patch(id, changes),
        ),
      );

  @override
  Future<void> deletePlant(String id) =>
      guardCall(() => _remote.remove(id));

  @override
  Future<Plant> markWatered(String id) => guardCall(
        () async => PlantModel.fromJson(await _remote.water(id)),
      );

  @override
  Future<Plant> markFertilized(String id) => guardCall(
        () async => PlantModel.fromJson(await _remote.fertilize(id)),
      );

  @override
  Future<Plant> uploadImage(
    String id,
    Uint8List imageBytes,
  ) =>
      guardCall(
        () async => PlantModel.fromJson(
          await _remote.uploadImage(id, imageBytes),
        ),
      );

  @override
  Future<PlantIdentification> identifyPlant(
    Uint8List imageBytes,
  ) =>
      guardCall(
        () async => PlantIdentification.fromJson(
          await _remote.identify(imageBytes),
        ),
      );
}
