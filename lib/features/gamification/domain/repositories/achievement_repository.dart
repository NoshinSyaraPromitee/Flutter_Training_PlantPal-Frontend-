import '../model/achievement.dart';

abstract class AchievementRepository {
  List<Achievement> getAchievements();
}