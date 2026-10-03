import '../../domain/model/plant.dart';

class PlantModel {
  PlantModel._();

  static DateTime? _date(dynamic v) =>
      v is String ? DateTime.tryParse(v)?.toLocal() : null;

  /// The backend sends timestamps, not a label, so derive the
  /// "Today / Tomorrow / In N days" label the UI expects.
  static String _waterLabel(DateTime? next) {
    if (next == null) return 'Not set';
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final days = DateTime(next.year, next.month, next.day)
        .difference(today)
        .inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'In $days days';
  }

  static Plant fromJson(Map<String, dynamic> j) {
    final roadmap = j['careRoadmap'] as Map<String, dynamic>?;
    final wateringTimes = (roadmap?['wateringTimes'] as List?)?.cast<String>();
    final nextWatering = _date(j['nextWateringAt'] ?? j['nextWatering']);

    return Plant(
      id: (j['id'] ?? j['_id'] ?? '').toString(),
      nickname: j['name'] as String? ?? j['nickname'] as String? ?? '',
      species: j['type'] as String? ?? j['species'] as String? ?? '',
      imageUrl: j['image'] as String? ?? '',
      location: j['location'] as String? ?? '',
      sunlight: j['sunlight'] as String? ?? '',
      health: (j['health'] as num?)?.round(),
      status: j['ageStage'] as String? ?? j['status'] as String? ?? '',
      humidity: j['humidity'] as String? ?? '',
      lastScan: _date(j['lastScan']),
      wateringFrequencyDays:
          (j['wateringFrequencyDays'] as num?)?.toInt() ??
              (wateringTimes?.length == 1 ? 1 : 7),
      lastWatered: _date(j['lastWateredAt'] ?? j['lastWatered']),
      nextWatering: nextWatering,
      lastFertilized: _date(j['lastFertilizedAt']),
      nextFertilizing: _date(j['nextFertilizingAt']),
      waterLevel: j['waterLevel'] as String? ?? _waterLabel(nextWatering),
      fertilizerNote: j['fertilizerNote'] as String? ??
          roadmap?['fertilizerRecommendation'] as String? ??
          '',
    );
  }

  /// POST /api/v1/plants reads name, type, ageStage, location, sunlight, wateringFrequencyDays.
  static Map<String, dynamic> newToJson(NewPlant p) => {
        'name': p.nickname.trim(),
        'type': p.species.trim(),
        'ageStage': 'mature',
        'location': p.location.trim(),
        'sunlight': p.sunlight.trim(),
        'wateringFrequencyDays': p.wateringFrequencyDays,
      };
}
