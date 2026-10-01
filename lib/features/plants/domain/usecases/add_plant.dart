import '../../../../core/network/failure.dart';
import '../model/plant.dart';
import '../repositories/plant_repository.dart';

/// Validates and creates a plant through the backend.
class AddPlant {
  AddPlant(this._repo);

  final PlantRepository _repo;

  Future<Plant> call(NewPlant input) async {
    final error = input.validate();
    if (error != null) throw Failure(error);

    return _repo.addPlant(input);
  }
}