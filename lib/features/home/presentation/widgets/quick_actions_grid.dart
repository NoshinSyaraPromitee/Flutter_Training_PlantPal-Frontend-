import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'menu_action_card.dart';

/// The 2-column grid of primary feature shortcuts on the home screen.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: MenuActionCard(
                icon: Icons.eco_outlined,
                label: l10n.myPlantsLabel,
                color: AppColors.green,
                onTap: () => context.push('/plants'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: MenuActionCard(
                icon: Icons.health_and_safety_outlined,
                label: l10n.diseaseDetectionTile,
                color: AppColors.teal,
                onTap: () => context.push('/scan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: MenuActionCard(
                icon: Icons.local_florist_outlined,
                label: l10n.fertilizerRecipesLabel,
                color: AppColors.orange,
                onTap: () => context.push('/fertilizer'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: MenuActionCard(
                icon: Icons.calendar_month_outlined,
                label: l10n.maintainance,
                color: AppColors.plum,
                onTap: () => context.push('/care-calendar'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        MenuActionCard(
          icon: Icons.storefront_outlined,
          label: l10n.shopLabel,
          color: AppColors.green,
          onTap: () => context.go('/shop'),
        ),
      ],
    );
  }
}
