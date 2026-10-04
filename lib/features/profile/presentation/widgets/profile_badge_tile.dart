import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'profile_badge_model.dart';

Color get _trackColor => AppColors.isDark ? Colors.white12 : Colors.black12;

/// Compact achievement card used in the profile grid.
class BadgeTile extends StatelessWidget {
  const BadgeTile({super.key, required this.badge});
  final ProfileBadge badge;

  @override
  Widget build(BuildContext context) {
    final on = badge.unlocked;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      radius: 16,
      onTap: () => showBadgeDetails(context, badge),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: on ? AppColors.surfaceGreen : _trackColor,
            child: Icon(on ? badge.icon : Icons.lock, size: 22, color: on ? AppColors.accent : AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            badge.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.inter(11, w: FontWeight.w700, c: on ? AppColors.textDark : AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class BadgeMedal extends StatelessWidget {
  const BadgeMedal({super.key, required this.badge, required this.size});
  final ProfileBadge badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final on = badge.unlocked;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? badge.color : _trackColor,
        border: Border.all(color: on ? Colors.white : Colors.transparent, width: 2.5),
        boxShadow: on ? [BoxShadow(color: badge.color.withValues(alpha: 0.45), blurRadius: 10, offset: const Offset(0, 3))] : null,
      ),
      child: Icon(on ? badge.icon : Icons.lock_outline, size: size * 0.5, color: on ? Colors.white : AppColors.textMuted),
    );
  }
}

Widget _bar(ProfileBadge b, double height) => ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(value: b.progress, minHeight: height, color: b.color, backgroundColor: _trackColor),
    );

void showBadgeDetails(BuildContext context, ProfileBadge b) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.isDark ? AppColors.surfaceGreen : AppColors.cream,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BadgeMedal(badge: b, size: 84),
          const SizedBox(height: 14),
          Text(b.label, style: AppTextStyles.inter(18, w: FontWeight.w800, c: AppColors.textDark)),
          const SizedBox(height: 6),
          Text(b.hint, textAlign: TextAlign.center, style: AppTextStyles.inter(13, c: AppColors.textMuted)),
          const SizedBox(height: 16),
          if (b.unlocked)
            Text('Unlocked!', style: AppTextStyles.inter(14, w: FontWeight.w800, c: b.color))
          else ...[
            _bar(b, 8),
            const SizedBox(height: 8),
            Text(b.progressText, style: AppTextStyles.inter(13, w: FontWeight.w700, c: AppColors.textDark)),
          ],
        ],
      ),
    ),
  );
}