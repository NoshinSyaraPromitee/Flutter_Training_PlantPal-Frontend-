import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'profile_badge_model.dart';
import 'profile_badge_tile.dart';

/// "Achievements" section: 4 cards per row, unlocked from real app data.
class ProfileBadges extends StatelessWidget {
  const ProfileBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = watchProfileBadges(context);
    final unlocked = badges.where((b) => b.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Achievements',
          trailing: Text(
            '$unlocked/${badges.length}',
            style: AppTextStyles.inter(13, w: FontWeight.w700, c: AppColors.brownHeading),
          ),
        ),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 30) / 4;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [for (final b in badges) SizedBox(width: w, child: BadgeTile(badge: b))],
            );
          },
        ),
      ],
    );
  }
}