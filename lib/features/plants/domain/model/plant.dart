import 'dart:typed_data';

class Plant {
  const Plant({
    required this.id,
    required this.nickname,
    required this.species,
    this.imageUrl = '',
    this.location = '',
    this.sunlight = '',
    this.health,
    this.status = '',
    this.humidity = '',
    this.lastScan,
    this.wateringFrequencyDays = 7,
    this.lastWatered,
    this.nextWatering,
    this.lastFertilized,
    this.nextFertilizing,
    this.waterLevel = 'Not set',
    this.fertilizerNote = '',
  });

  final String id,
      nickname,
      species,
      imageUrl,
      location,
      sunlight,
      status,
      humidity,
      waterLevel,
      fertilizerNote;
  final int? health; // 0-100, null until scanned
  final int wateringFrequencyDays;
  final DateTime? lastScan,
      lastWatered,
      nextWatering,
      lastFertilized,
      nextFertilizing;

  Plant copyWith({DateTime? lastScan}) => Plant(
    id: id,
    nickname: nickname,
    species: species,
    imageUrl: imageUrl,
    location: location,
    sunlight: sunlight,
    health: health,
    status: status,
    humidity: humidity,
    lastScan: lastScan ?? this.lastScan,
    wateringFrequencyDays: wateringFrequencyDays,
    lastWatered: lastWatered,
    nextWatering: nextWatering,
    lastFertilized: lastFertilized,
    nextFertilizing: nextFertilizing,
    waterLevel: waterLevel,
    fertilizerNote: fertilizerNote,
  );
}

class NewPlant {
  const NewPlant({
    required this.nickname,
    required this.species,
    this.location = '',
    this.sunlight = '',
    this.wateringFrequencyDays = 7,
    this.lastWatered,
    this.imageBytes,
  });

  final String nickname, species, location, sunlight;
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
