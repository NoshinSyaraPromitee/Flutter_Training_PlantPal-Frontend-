import '../../domain/model/plant.dart';

class PlantModel {
  PlantModel._();

  static DateTime? _date(dynamic v) =>
      v is String ? DateTime.tryParse(v)?.toLocal() : null;

  static PlantScan? _scan(dynamic v) {
    if (v is! Map) return null;
    final at = _date(v['at']);
    if (at == null) return null;
    return PlantScan(
      issue: v['issue']?.toString() ?? '',
      severity: v['severity']?.toString() ?? '',
      at: at,
      id: v['id']?.toString() ?? '',
      treated: v['treated'] == true,
    );
  }

  static List<HealthReason> _reasons(dynamic v) => v is List
      ? [
          for (final r in v)
            if (r is Map)
              HealthReason(
                code: r['code']?.toString() ?? '',
                value: (r['value'] as num?)?.toInt(),
                detail: r['detail']?.toString() ?? '',
                severity: r['severity']?.toString() ?? '',
                impact: (r['impact'] as num?)?.toInt() ?? 0,
              ),
        ]
      : const [];

  static Plant fromJson(Map<String, dynamic> j) {
    final roadmap = j['careRoadmap'] as Map<String, dynamic>?;
    final wateringTimes = (roadmap?['wateringTimes'] as List?)?.cast<String>();

    return Plant(
      id: (j['id'] ?? j['_id'] ?? '').toString(),
      nickname: j['name'] as String? ?? j['nickname'] as String? ?? '',
      species: j['type'] as String? ?? j['species'] as String? ?? '',
      imageUrl: j['image'] as String? ?? '',
      location: j['location'] as String? ?? '',
      sunlight: j['sunlight'] as String? ?? '',
      isOutdoor: j['outdoor'] == true,
      health: (j['health'] as num?)?.round() ?? 100,
      healthState: HealthState.parse(j['healthState'] as String?),
      healthReasons: _reasons(j['healthReasons']),
      status: j['ageStage'] as String? ?? j['status'] as String? ?? '',
      humidity: j['humidity'] as String? ?? '',
      lastScan: _scan(j['lastScan']),
      wateringFrequencyDays:
          (j['wateringFrequencyDays'] as num?)?.toInt() ??
              (wateringTimes?.length == 1 ? 1 : 7),
      lastWatered: _date(j['lastWateredAt'] ?? j['lastWatered']),
      nextWatering: _date(j['nextWateringAt'] ?? j['nextWatering']),
      lastFertilized: _date(j['lastFertilizedAt']),
      nextFertilizing: _date(j['nextFertilizingAt']),
      fertilizerNote: j['fertilizerNote'] as String? ??
          roadmap?['fertilizerRecommendation'] as String? ??
          '',
      careTips: roadmap?['tips'] as String? ?? '',
      waterAmountMl: (roadmap?['waterAmountMl'] as num?)?.toInt() ?? 0,
      fertilizingIntervalDays:
          (roadmap?['fertilizingIntervalDays'] as num?)?.toInt() ?? 0,
      createdAt: _date(j['createdAt']),
    );
  }

  /// POST /api/v1/plants reads name, type, location, sunlight, outdoor,
  /// wateringFrequencyDays and lastWateredAt. `lastWateredAt` is omitted when
  /// the plant was not just watered, which makes it due right now.
  /// `ageStage` is sent only when the user picked a stage. `waterAmountMl`
  /// and `careTips` carry the AI-identify values into the care roadmap
  /// (PLAN.md 3.3); they are omitted when unknown.
  static Map<String, dynamic> newToJson(NewPlant p) => {
        'name': p.nickname.trim(),
        'type': p.species.trim(),
        if (p.ageStage.trim().isNotEmpty) 'ageStage': p.ageStage.trim(),
        'location': p.location.trim(),
        'sunlight': p.sunlight.trim(),
        'outdoor': p.outdoor,
        'wateringFrequencyDays': p.wateringFrequencyDays,
        if (p.waterAmountMl > 0) 'waterAmountMl': p.waterAmountMl,
        if (p.careTips.trim().isNotEmpty) 'careTips': p.careTips.trim(),
        if (p.lastWatered != null)
          'lastWateredAt': p.lastWatered!.toUtc().toIso8601String(),
      };
}
