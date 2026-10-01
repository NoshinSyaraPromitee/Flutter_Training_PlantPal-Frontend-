import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';

class AchievementsSection extends ConsumerWidget {
  const AchievementsSection({super.key});

  static const _icons = {
    'seed': Icons.grain,
    'water': Icons.water_drop,
    'leaf': Icons.eco,
    'camera': Icons.photo_camera,
    'trophy': Icons.emoji_events,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final badges = ref.read(achievementRepositoryProvider).getAchievements();
    final w = (MediaQuery.of(context).size.width - 40 - 30) / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.achievementsTitle),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final b in badges)
              SizedBox(
                width: w,
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  radius: 16,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: b.unlocked
                            ? AppColors.surfaceGreen
                            : const Color(0xFFF0F0F0),
                        child: Icon(
                          b.unlocked ? _icons[b.key] : Icons.lock,
                          size: 22,
                          color: b.unlocked
                              ? AppColors.greenPrimary
                              : Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        b.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTextStyles.inter(
                          10,
                          w: FontWeight.w600,
                          c: b.unlocked
                              ? AppColors.textDark
                              : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}