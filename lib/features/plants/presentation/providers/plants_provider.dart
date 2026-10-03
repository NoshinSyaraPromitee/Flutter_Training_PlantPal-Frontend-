import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/network/failure.dart';
import '../../domain/model/care_task.dart';
import '../../domain/model/history_entry.dart';
import '../../domain/model/plant.dart';
import '../../domain/model/plant_event.dart';
import '../../domain/repositories/plant_repository.dart';
import '../../domain/usecases/add_plant.dart';
import '../../domain/usecases/care_tasks.dart';
import '../../domain/usecases/plant_history.dart';

class PlantsController extends ChangeNotifier {
  PlantsController({
    required PlantRepository repository,
    required AddPlant addPlant,
  }) : _repo = repository,
       _add = addPlant;

  final PlantRepository _repo;
  final AddPlant _add;
  final _buildCareTasks = const BuildCareTasks();
  final _buildHistory = const BuildPlantHistory();

  /// Called with the points earned when a *due* care action is logged.
  /// Wired to PointsController.add in app_dependencies.dart.
  void Function(int points)? onCareLogged;

  List<Plant> plants = const [];
  List<PlantEvent> events = const [];
  bool loading = false;
  bool loaded = false;
  String? error;

  /// Derived views for the UI (the screens never call use cases directly).
  List<CareTask> get careTasks => _buildCareTasks(plants);
  List<HistoryEntry> get history => _buildHistory(events, plants);

  Future<void> load({bool force = false}) async {
    if (loading || (loaded && !force)) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      plants = await _repo.getPlants();
      try {
        events = await _repo.getEvents();
      } catch (_) {
        events = const [];
      }
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

  /// Plants whose watering is due today or overdue (from the dates).
  int get waterTodayCount => plants.where((p) => p.isWaterDue).length;

  /// Plants whose fertilizing is due today or overdue.
  int get feedDueCount => plants.where((p) => p.isFertilizeDue).length;

  /// Plants whose health is "needs care" or "critical".
  int get needAttentionCount => plants.where((p) => p.needsAttention).length;

  int get thrivingCount =>
      plants.where((p) => p.healthState == HealthState.thriving).length;

  int get lastActionPointsEarned => _lastPointsEarned;

  /// The plant that has waited longest for water, or null if none is due.
  Plant? get thirstiestPlant {
    Plant? best;
    for (final p in plants) {
      if (!p.isWaterDue) continue;
      if (best == null || p.nextWatering!.isBefore(best.nextWatering!)) {
        best = p;
      }
    }
    return best;
  }

  /// Consecutive days with a logged watering or a skip/snooze across the garden.
  int get wateringStreak {
    final activityDates = <DateTime>{};
    for (final event in events) {
      final created = event.createdAt;
      final day = DateTime(created.year, created.month, created.day);
      if (event.eventType == 'water' || event.eventType == 'fertilize') {
        activityDates.add(day);
      }
      if (event.eventType == 'skip') {
        final snoozeDays = (event.metadata['snoozeDays'] as num?)?.toInt() ?? 1;
        for (var offset = 0; offset < snoozeDays; offset++) {
          activityDates.add(day.add(Duration(days: offset)));
        }
      }
    }
    final dates = activityDates.toList()..sort((a, b) => b.compareTo(a));

    if (dates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // If no watering today or yesterday, streak is broken.
    final mostRecent = dates.first;
    if (mostRecent.isBefore(yesterday)) return 0;

    var streak = 0;
    var expected = mostRecent;

    for (final d in dates) {
      if (d == expected) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  /// Each action returns an error message, or null on success.
  Future<String?> add(NewPlant input) => _run(() async {
    final created = await _add(input);
    plants = [created, ...plants];
  });

  /// POST /plants/{id}/water
  Future<String?> markWatered(String id) => _run(() async {
    _lastPointsEarned = 0;
    final result = await _repo.markWatered(id);
    plants = [for (final p in plants) p.id == id ? result.plant : p];
    _lastPointsEarned = result.pointsEarned;
    onCareLogged?.call(result.pointsEarned);
    await _refreshGardenEvents();
  });

  // ---- Undoable watering (My Plants one-tap button, details "Next up") ----
  // There is no "un-water" endpoint, so the call is held back for
  // [undoWindow]; Undo inside the window simply cancels it.
  static const Duration undoWindow = Duration(seconds: 5);
  final Map<String, Timer> _pendingWater = {};

  /// True while a watering is queued (shown as done, API call not sent yet).
  bool isWaterPending(String id) => _pendingWater.containsKey(id);

  /// Queues a watering. Returns true when queued, or null if unavailable.
  /// [onError] gets the API error message if the delayed call fails;
  /// [onDone] gets the server-validated points once it succeeded.
  bool? queueWater(
    String id, {
    void Function(String message)? onError,
    void Function(int pointsEarned)? onDone,
  }) {
    final p = byId(id);
    if (p == null || _pendingWater.containsKey(id)) return null;
    _pendingWater[id] = Timer(undoWindow, () async {
      final err = await markWatered(id);
      final points = _lastPointsEarned;
      _pendingWater.remove(id);
      notifyListeners();
      if (err != null) {
        onError?.call(err);
      } else {
        onDone?.call(points);
      }
    });
    notifyListeners();
    return true;
  }

  /// Cancels a queued watering (no-op if it was already sent).
  void undoWater(String id) {
    final timer = _pendingWater.remove(id);
    if (timer == null) return;
    timer.cancel();
    notifyListeners();
  }

  /// Waters every plant that is due now. Returns how many succeeded, the
  /// points earned and the first error message, if any.
  Future<({int count, int points, String? error})> waterAllDue() async {
    final ids = [
      for (final p in plants)
        if (p.isWaterDue && !isWaterPending(p.id)) p.id,
    ];
    var done = 0;
    var points = 0;
    String? error;
    for (final id in ids) {
      final err = await markWatered(id);
      if (err == null) {
        done++;
        points += _lastPointsEarned;
      } else {
        error ??= err;
      }
    }
    return (count: done, points: points, error: error);
  }

  /// POST /plants/{id}/fertilize
  Future<String?> markFertilized(String id) => _run(() async {
    _lastPointsEarned = 0;
    final result = await _repo.markFertilized(id);
    plants = [for (final p in plants) p.id == id ? result.plant : p];
    _lastPointsEarned = result.pointsEarned;
    onCareLogged?.call(result.pointsEarned);
    await _refreshGardenEvents();
  });

  Future<String?> skipWatering(
    String id, {
    required String reason,
    required int days,
  }) => _run(() async {
    final updated = await _repo.skipWatering(id, reason: reason, days: days);
    plants = [for (final p in plants) p.id == id ? updated : p];
    await _refreshGardenEvents();
  });

  Future<String?> addNote(String id, String note) => _run(() async {
    await _repo.addNote(id, note);
    await _refreshGardenEvents();
  });

  Future<void> loadPlantEvents(String plantId) async {
    try {
      final loadedEvents = await _repo.getEvents(plantId: plantId);
      final byEventId = {for (final event in events) event.id: event};
      for (final event in loadedEvents) {
        byEventId[event.id] = event;
      }
      events = byEventId.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (_) {}
  }

  int _lastPointsEarned = 0;

  Future<void> _refreshGardenEvents() async {
    try {
      events = await _repo.getEvents();
    } catch (_) {}
  }

  /// PATCH /plants/{id} updates nickname, species, location, sunlight, ageStage, and wateringFrequencyDays.
  Future<String?> updateDetails({
    required String id,
    required String nickname,
    required String species,
    required String location,
    required String sunlight,
    required int wateringFrequencyDays,
    String? ageStage,
    bool? outdoor,
  }) => _run(() async {
    final payload = <String, dynamic>{
      'name': nickname,
      'type': species,
      'location': location,
      'sunlight': sunlight,
      'wateringFrequencyDays': wateringFrequencyDays,
    };
    if (ageStage != null) {
      payload['ageStage'] = ageStage;
    }
    if (outdoor != null) {
      payload['outdoor'] = outdoor;
    }
    final updated = await _repo.updatePlant(id, payload);
    plants = [for (final p in plants) p.id == id ? updated : p];
  });

  /// POST /plants/{id}/image updates the plant photo.
  Future<String?> uploadImage(String id, Uint8List imageBytes) =>
      _run(() async {
        final updated = await _repo.uploadImage(id, imageBytes);
        plants = [for (final p in plants) p.id == id ? updated : p];
      });

  /// POST /plants/identify identifies a plant species and care requirements from photo.
  Future<PlantIdentification?> identifyPlant(Uint8List imageBytes) async {
    try {
      return await _repo.identifyPlant(imageBytes);
    } catch (e) {
      error = Failure.from(e).message;
      notifyListeners();
      return null;
    }
  }

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
    for (final t in _pendingWater.values) {
      t.cancel();
    }
    _pendingWater.clear();
    plants = const [];
    events = const [];
    loaded = false;
    error = null;
    notifyListeners();
  }
}
