import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.route, this.color);
  final IconData icon;
  final String label;
  final String route;
  final Color color;
}

final _menu = [
  _MenuItem(Icons.local_florist, 'My Plants', '/plants', AppColors.green),
  _MenuItem(
    Icons.event_available,
    'Care Calendar',
    '/care-calendar',
    AppColors.teal,
  ),
  _MenuItem(Icons.eco, 'Care Guide', '/care-guide', AppColors.green),
  _MenuItem(
    Icons.science_outlined,
    'Fertilizer Recipes',
    '/fertilizer',
    AppColors.orange,
  ),
  _MenuItem(Icons.history, 'Plant History', '/plant-history', AppColors.plum),
  _MenuItem(Icons.favorite_border, 'Wishlist', '/wishlist', AppColors.plum),
  _MenuItem(Icons.shopping_cart_outlined, 'My Cart', '/cart', AppColors.orange),
  _MenuItem(Icons.receipt_long_outlined, 'My Orders', '/orders', AppColors.teal),
];

/// Grid of quick-link cards into the rest of the app, shown on the profile tab.
class QuickMenuGrid extends StatelessWidget {
  const QuickMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.6,
      children: [
        for (final item in _menu)
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            onTap: () => context.push(item.route),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: item.color.withValues(alpha: 0.14),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
