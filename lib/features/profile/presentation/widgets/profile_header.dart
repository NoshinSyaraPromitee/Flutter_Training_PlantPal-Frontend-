import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../plants/presentation/providers/plants_provider.dart';
import 'profile_badge_model.dart';

/// Avatar, name and the Plants / Avg Health / Badges summary.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantsController>();
    final badges = watchProfileBadges(context).where((b) => b.unlocked).length;
    final top = AppColors.isDark ? AppColors.surfaceGreen : AppColors.cream;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [top, AppColors.greenCardFill]),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 40, backgroundColor: AppColors.greenPrimary, child: Icon(Icons.spa, size: 44, color: AppColors.cream)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.displayMedium.copyWith(fontSize: 26, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 2),
                    Text('Plant Parent since 2026', style: AppTextStyles.inter(14, c: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _Stat('${plants.plants.length}', 'Plants'),
              _Stat('${plants.averageHealth}%', 'Avg Health'),
              _Stat('$badges', 'Badges'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value, style: AppTextStyles.inter(26, w: FontWeight.w800, c: AppColors.accent)),
            Text(label, style: AppTextStyles.inter(13, c: AppColors.textMuted)),
          ],
        ),
      );
}