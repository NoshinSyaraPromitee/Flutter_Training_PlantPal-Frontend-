import 'plant.dart';

class PlantEvent {
  const PlantEvent({
    required this.id,
    required this.plantId,
    required this.eventType,
    required this.createdAt,
    this.reason = '',
    this.note = '',
    this.points = 0,
    this.imageUrl = '',
    this.metadata = const {},
  });

  factory PlantEvent.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    return PlantEvent(
      id: json['id']?.toString() ?? '',
      plantId: json['plantId']?.toString() ?? '',
      eventType: json['eventType']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      reason: json['reason']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      metadata: metadata is Map
          ? metadata.map((key, value) => MapEntry(key.toString(), value))
          : const {},
    );
  }

  final String id;
  final String plantId;
  final String eventType;
  final String reason;
  final String note;
  final int points;
  final String imageUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
}

class PlantActionResult {
  const PlantActionResult({required this.plant, required this.pointsEarned});

  final Plant plant;
  final int pointsEarned;
}
