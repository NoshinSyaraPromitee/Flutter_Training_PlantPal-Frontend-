import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../../ai_doctor/domain/repositories/ai_doctor_repository.dart';
import '../../domain/model/plant.dart';
import '../../domain/repositories/plant_repository.dart';
import '../../domain/usecases/add_plant.dart';

class PlantsController extends ChangeNotifier {
  PlantsController({
    required PlantRepository repository,
    required AddPlant addPlant,
    this._scans,
  })  : _repo = repository,
        _add = addPlant;
  final PlantRepository _repo;
  final AddPlant _add;

  /// Source of saved scans (GET /diagnoses), used to fill in each plant's
  /// last-scan date, which the plants API doesn't carry itself.
  final AiDoctorRepository? _scans;

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
      plants = await _withScans(await _repo.getPlants());
      loaded = true;
    } catch (e) {
      error = Failure.from(e).message;
    }
    loading = false;
    notifyListeners();
  }

  /// Stamps each plant with the date of its newest saved scan. Best effort:
  /// if the scan history can't be fetched the plants are returned unchanged.
  Future<List<Plant>> _withScans(List<Plant> list) async {
    final repo = _scans;
    if (repo == null || list.isEmpty) return list;
    try {
      final latest = <String, DateTime>{};
      for (final d in await repo.diagnosisHistory()) {
        final plantId = d.plantId, at = d.createdAt;
        if (plantId == null || at == null) continue;
        final current = latest[plantId];
        if (current == null || at.isAfter(current)) latest[plantId] = at;
      }
      return [
        for (final p in list)
          latest.containsKey(p.id) ? p.copyWith(lastScan: latest[p.id]) : p,
      ];
    } catch (_) {
      return list;
    }
  }

  /// Re-reads scan dates, e.g. after a scan linked to a plant was saved.
  Future<void> refreshScans() async {
    plants = await _withScans(plants);
    notifyListeners();
  }

  // A plant returned by the API carries no scan date; keep the one we know.
  Plant _keepScan(Plant old, Plant updated) =>
      updated.lastScan == null ? updated.copyWith(lastScan: old.lastScan) : updated;

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
        plants = [for (final p in plants) p.id == id ? _keepScan(p, updated) : p];
      });

  Future<String?> updateDetails({
    required String id,
    required String nickname,
    required String species,
    required String location,
    required String sunlight,
    required int wateringFrequencyDays,
  }) =>
      _run(() async {
        final updated = await _repo.updatePlant(id, {
          'nickname': nickname,
          'species': species,
          'location': location,
          'sunlight': sunlight,
          'wateringFrequencyDays': wateringFrequencyDays,
        });
        plants = [for (final p in plants) p.id == id ? _keepScan(p, updated) : p];
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