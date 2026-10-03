import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../gamification/presentation/providers/points_provider.dart';
import '../../../plants/presentation/providers/plants_provider.dart';

class ProfileBadge {
  const ProfileBadge({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
    required this.current,
    required this.target,
    this.unit = '',
  });

  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  final int current;
  final int target;
  final String unit;

  bool get unlocked => current >= target;
  double get progress => target == 0 ? 1 : (current / target).clamp(0.0, 1.0);
  String get progressText => '${current.clamp(0, target)}$unit / $target$unit';
}

/// Badges for the current user, rebuilt whenever plants or points change.
List<ProfileBadge> watchProfileBadges(BuildContext context) {
  final plants = context.watch<PlantsController>();
  final count = plants.plants.length;
  return buildProfileBadges(
    plants: count,
    health: count > 0 ? plants.averageHealth : 0,
    watered: plants.waterTodayCount,
    points: context.watch<PointsController>().balance,
  );
}

List<ProfileBadge> buildProfileBadges({
  required int plants,
  required int health,
  required int watered,
  required int points,
}) =>
    [
      ProfileBadge(icon: Icons.grass, label: 'First Sprout', hint: 'Add your first plant', color: const Color(0xFF66BB6A), current: plants, target: 1),
      ProfileBadge(icon: Icons.water_drop, label: 'Hydration Hero', hint: 'Water a plant today', color: const Color(0xFF42A5F5), current: watered, target: 1),
      ProfileBadge(icon: Icons.shower, label: 'Rain Maker', hint: 'Water 3 plants in one day', color: const Color(0xFF26C6DA), current: watered, target: 3),
      ProfileBadge(icon: Icons.eco, label: 'Green Thumb', hint: 'Keep average plant health at 80% or more', color: const Color(0xFF2E7D32), current: health, target: 80, unit: '%'),
      ProfileBadge(icon: Icons.favorite, label: 'Picture of Health', hint: 'Reach 100% average plant health', color: const Color(0xFFE53935), current: health, target: 100, unit: '%'),
      ProfileBadge(icon: Icons.local_florist, label: 'Plant Parent', hint: 'Have 5 plants in your garden', color: const Color(0xFFEC407A), current: plants, target: 5),
      ProfileBadge(icon: Icons.emoji_events, label: 'Plant Legend', hint: 'Grow a garden of 10 plants', color: const Color(0xFFFF7043), current: plants, target: 10),
      ProfileBadge(icon: Icons.stars, label: 'Point Collector', hint: 'Earn 100 care points', color: const Color(0xFFFFB300), current: points, target: 100),
      ProfileBadge(icon: Icons.workspace_premium, label: 'Care Champion', hint: 'Earn 500 care points', color: const Color(0xFF8E24AA), current: points, target: 500),
    ];