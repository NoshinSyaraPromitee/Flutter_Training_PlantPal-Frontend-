import 'package:flutter/foundation.dart';
import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/features/gamification/presentation/providers/points_provider.dart';
import 'package:plantpal/features/plants/domain/model/plant.dart';
import 'package:plantpal/features/plants/domain/repositories/plant_repository.dart';
import 'package:plantpal/features/plants/domain/usecases/add_plant.dart';

/// Points awarded for each completed care step (currently: watering).
const pointsPerCareStep = 10;

class PlantsController extends ChangeNotifier {
  PlantsController({required PlantRepository repository, required AddPlant addPlant, PointsController? points})
      : _repo = repository,
        _add = addPlant,
        _points = points;
  final PlantRepository _repo;
  final AddPlant _add;
  final PointsController? _points;

  List<Plant> plants = const [];
  bool loading = false;
  bool loaded = false;
  String? error;

  Future<void> load({bool force = false}) async {
    if (loading || (loaded && !force)) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
           plants = await _repo.getPlants(forceRefresh: force);
      loaded = true;
    } catch (e) {
      error = Failure.from(e).message;
    }
    loading = false;
    notifyListeners();
  }

  Plant? byId(String id) {
    for (final p in plants) {
      if (p.id == id) return p;
    }
    return null;
  }

  int get averageHealth {
    final scanned = plants.where((p) => p.health != null).toList();
    if (scanned.isEmpty) return 0;
    return (scanned.fold<int>(0, (s, p) => s + p.health!) / scanned.length).round();
  }

  int get waterTodayCount => plants.where((p) => p.waterLevel == 'Today').length;

  /// Each action returns an error message, or null on success.
  Future<String?> add(NewPlant input) => _run(() async {
        final created = await _add(input);
        plants = [created, ...plants];
      });

  Future<String?> markWatered(String id) => _run(() async {
        final updated = await _repo.updatePlant(id, {'lastWatered': DateTime.now().toUtc().toIso8601String()});
        plants = [for (final p in plants) p.id == id ? updated : p];
        _points?.add(pointsPerCareStep);
      });

  Future<String?> remove(String id) => _run(() async {
        await _repo.deletePlant(id);
        plants = plants.where((p) => p.id != id).toList();
      });

  Future<String?> _run(Future<void> Function() action) async {
    try {
      await action();
      notifyListeners();
      return null;
    } catch (e) {
      return Failure.from(e).message;
    }
  }

  void clear() {
    plants = const [];
    loaded = false;
    error = null;
    notifyListeners();
  }
}