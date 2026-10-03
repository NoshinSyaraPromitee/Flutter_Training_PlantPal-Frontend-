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

    final created = await _repo.addPlant(input);
    if (input.imageBytes != null) {
      try {
        return await _repo.uploadImage(created.id, input.imageBytes!);
      } catch (_) {
        // If image upload fails, return the created plant anyway
        return created;
      }
    }
    return created;
  }
}