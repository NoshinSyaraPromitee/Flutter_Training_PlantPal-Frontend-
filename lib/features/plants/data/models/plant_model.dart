import '../../domain/model/plant.dart';

class PlantModel {
  PlantModel._();

  static DateTime? _date(dynamic v) => v is String ? DateTime.tryParse(v)?.toLocal() : null;

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
        health: (j['health'] as num?)?.round(),
        status: j['ageStage'] as String? ?? j['status'] as String? ?? '',
        humidity: j['humidity'] as String? ?? '',
        lastScan: _date(j['lastScan']),
        wateringFrequencyDays:
            (j['wateringFrequencyDays'] as num?)?.toInt() ??
            (wateringTimes?.length == 1 ? 1 : 7),
        lastWatered: _date(j['lastWatered']),
        nextWatering: _date(j['nextWatering']),
        waterLevel: j['waterLevel'] as String? ?? 'Not set',
        fertilizerNote: j['fertilizerNote'] as String? ??
            roadmap?['fertilizerRecommendation'] as String? ??
            '');
  }

  static Map<String, dynamic> newToJson(NewPlant p) => {
        'name': p.nickname.trim(),
        'type': p.species.trim(),
        'ageStage': 'mature',
        'location': p.location.trim(),
        'sunlight': p.sunlight.trim(),
        'wateringFrequencyDays': p.wateringFrequencyDays,
        if (p.lastWatered != null) 'lastWatered': p.lastWatered!.toUtc().toIso8601String(),
      };
}