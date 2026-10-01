import '../../domain/model/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';

/// Static badges for now.
class AchievementLocalRepository implements AchievementRepository {
  @override
  List<Achievement> getAchievements() => const [
        Achievement('seed', 'First Sprout', true),
        Achievement('water', 'Hydration Hero', true),
        Achievement('leaf', 'Green Thumb', true),
        Achievement('camera', 'Scan Master', true),
        Achievement('trophy', 'Plant Legend', false),
      ];
}