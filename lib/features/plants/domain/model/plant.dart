import 'dart:typed_data';

import '../../../../core/utils/formatters.dart';

/// Server-computed health bucket (see PLAN.md 3.2).
enum HealthState {
  thriving,
  okay,
  needsCare,
  critical;

  static HealthState parse(String? v) => switch (v) {
        'thriving' => HealthState.thriving,
        'okay' => HealthState.okay,
        'needs_care' => HealthState.needsCare,
        'critical' => HealthState.critical,
        _ => HealthState.thriving,
      };
}

/// One deduction from the health score. The server sends a [code] only;
/// the UI turns it into text (l10n).
class HealthReason {
  const HealthReason({
    required this.code,
    this.value,
    this.detail = '',
    this.severity = '',
    this.impact = 0,
  });

  static const waterLate = 'water_late';
  static const fertilizerLate = 'fertilizer_late';
  static const scanIssue = 'scan_issue';

  final String code;

  /// Whole days late (water_late / fertilizer_late).
  final int? value;

  /// The scan issue text (scan_issue).
  final String detail;

  /// mild | moderate | severe (scan_issue).
  final String severity;

  /// Points taken off the score (negative).
  final int impact;
}

/// The latest AI Doctor scan saved against a plant.
class PlantScan {
  const PlantScan({
    required this.issue,
    this.severity = '',
    required this.at,
    this.id = '',
    this.treated = false,
  });

  /// The diagnosis id and whether the user marked it as treated.
  final String id;
  final bool treated;
  final String issue;

  /// Mild | Moderate | Severe | none (as sent by the server).
  final String severity;
  final DateTime at;
}

class Plant {
  const Plant({
    required this.id,
    required this.nickname,
    required this.species,
    this.imageUrl = '',
    this.location = '',
    this.sunlight = '',
    this.isOutdoor = false,
    this.health = 100,
    this.healthState = HealthState.thriving,
    this.healthReasons = const [],
    this.status = '',
    this.humidity = '',
    this.lastScan,
    this.wateringFrequencyDays = 7,
    this.lastWatered,
    this.nextWatering,
    this.lastFertilized,
    this.nextFertilizing,
    this.fertilizerNote = '',
    this.careTips = '',
    this.waterAmountMl = 0,
    this.fertilizingIntervalDays = 0,
    this.createdAt,
  });

  final String id,
      nickname,
      species,
      imageUrl,
      location,
      sunlight,
      status,
      humidity,
      fertilizerNote,
      careTips;

  /// Lives outside (garden, balcony): gets the weather-aware tips.
  final bool isOutdoor;

  /// 10-100, computed by the backend on every read.
  final int health;
  final HealthState healthState;
  final List<HealthReason> healthReasons;
  final PlantScan? lastScan;
  final int wateringFrequencyDays;

  /// From the care roadmap: ml per watering (0 = unknown) and days between
  /// fertilizing (0 = unknown).
  final int waterAmountMl, fertilizingIntervalDays;
  final DateTime? lastWatered,
      nextWatering,
      lastFertilized,
      nextFertilizing,
      createdAt;

  /// Stored as ageStage on the backend, preserved as status for backwards compat.
  String get ageStage => status;

  /// Local calendar days until the next watering (negative = overdue).
  int? get waterDueInDays =>
      nextWatering == null ? null : calendarDaysUntil(nextWatering!);

  /// Watering is due today or overdue.
  bool get isWaterDue => (waterDueInDays ?? 1) <= 0;

  /// Local calendar days until the next fertilizing (negative = overdue).
  int? get fertilizeDueInDays =>
      nextFertilizing == null ? null : calendarDaysUntil(nextFertilizing!);

  bool get isFertilizeDue => (fertilizeDueInDays ?? 1) <= 0;

  /// Days between fertilizing: the roadmap value, else derived from the
  /// last/next dates, else 0 (unknown).
  int get fertilizeIntervalDays {
    if (fertilizingIntervalDays > 0) return fertilizingIntervalDays;
    if (lastFertilized != null && nextFertilizing != null) {
      final d = nextFertilizing!.difference(lastFertilized!).inDays;
      if (d > 0) return d;
    }
    return 0;
  }

  /// Smallest "days until due" of watering and fertilizing (negative =
  /// overdue). Used to sort the garden by urgency; no schedule sorts last.
  int get urgencyDays {
    final w = waterDueInDays ?? 9999;
    final f = fertilizeDueInDays ?? 9999;
    return w < f ? w : f;
  }

  /// Health says the plant needs care or is critical.
  bool get needsAttention =>
      healthState == HealthState.needsCare ||
      healthState == HealthState.critical;
}

class NewPlant {
  const NewPlant({
    required this.nickname,
    required this.species,
    this.location = '',
    this.sunlight = '',
    this.outdoor = false,
    this.wateringFrequencyDays = 7,
    this.lastWatered,
    this.imageBytes,
    this.ageStage = '',
    this.waterAmountMl = 0,
    this.careTips = '',
  });

  final String nickname, species, location, sunlight;

  /// The plant lives outside (garden, balcony).
  final bool outdoor;

  /// Seedling | Young | Mature, or '' to let the backend default apply.
  final String ageStage;

  /// Kept from the AI identify result (0 = unknown) so the saved care
  /// roadmap matches what the user saw in the plan preview.
  final int waterAmountMl;
  final String careTips;
  final int wateringFrequencyDays;
  final DateTime? lastWatered;
  final Uint8List? imageBytes;

  String? validate() {
    if (nickname.trim().isEmpty || species.trim().isEmpty) {
      return 'Please enter at least the plant nickname and species.';
    }
    if (wateringFrequencyDays < 1) {
      return 'Watering interval must be at least 1 day.';
    }
    return null;
  }
}

class PlantIdentification {
  const PlantIdentification({
    required this.species,
    this.suggestedNickname = '',
    this.location = '',
    this.sunlight = '',
    this.wateringFrequencyDays = 7,
    this.waterAmountMl = 250,
    this.health = 90,
    this.careTips = '',
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> j) =>
      PlantIdentification(
        species: j['species']?.toString() ?? '',
        suggestedNickname: j['suggestedNickname']?.toString() ?? '',
        location: j['location']?.toString() ?? '',
        sunlight: j['sunlight']?.toString() ?? '',
        wateringFrequencyDays:
            (j['wateringFrequencyDays'] as num?)?.toInt() ?? 7,
        waterAmountMl: (j['waterAmountMl'] as num?)?.toInt() ?? 250,
        health: (j['health'] as num?)?.toInt() ?? 90,
        careTips: j['careTips']?.toString() ?? '',
      );

  final String species;
  final String suggestedNickname;
  final String location;
  final String sunlight;
  final int wateringFrequencyDays;
  final int waterAmountMl;
  final int health;
  final String careTips;
}
