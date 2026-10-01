import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';

/// Compact row used for "Recent Plants" on Home.
class PlantSummaryCard extends StatelessWidget {
  const PlantSummaryCard({
    super.key,
    required this.plant,
  });

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => context.push('/plants/${plant.id}'),
      child: Row(
        children: [
          const Icon(
            Icons.local_florist,
            size: 40,
            color: AppColors.greenPrimary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.nickname,
                  style: AppTextStyles.inter(
                    17,
                    w: FontWeight.w700,
                  ),
                ),
                Text(
                  l10n.plantWaterLevelLabel(plant.waterLevel),
                  style: AppTextStyles.inter(
                    13,
                    c: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.greenPrimary,
          ),
        ],
      ),
    );
  }
}