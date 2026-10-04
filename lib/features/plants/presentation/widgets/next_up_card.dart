import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../utils/care_actions.dart';
import '../utils/due_text.dart';

/// The single next care action for a plant, with one big button.
/// Water first, then fertilize; when nothing is due it shows the next date.
class NextUpCard extends ConsumerWidget {
  const NextUpCard({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = ref.watch(plantsControllerProvider);
    final pending = c.isWaterPending(plant.id);

    late final IconData icon;
    late final Color color;
    late final String headline;
    late final String detail;
    late final String buttonLabel;
    late final AppButtonVariant variant;
    VoidCallback? onPressed;

    if (pending) {
      icon = Icons.check_circle;
      color = const Color(0xFF43A047);
      headline = l10n.nextUpAllDone;
      detail = l10n.statusWatered;
      buttonLabel = l10n.statusWatered;
      variant = AppButtonVariant.secondary;
    } else if (plant.isWaterDue) {
      icon = Icons.water_drop;
      color = AppColors.waterBlue;
      headline = l10n.scheduleWater;
      detail = dueText(l10n, plant.waterDueInDays);
      buttonLabel = plant.waterAmountMl > 0
          ? l10n.nextUpWaterNowMl(plant.waterAmountMl)
          : l10n.nextUpWaterNow;
      variant = AppButtonVariant.green;
      onPressed = () => CareActions.water(context, c, plant);
    } else if (plant.isFertilizeDue) {
      icon = Icons.eco;
      color = const Color(0xFFB77900);
      headline = l10n.scheduleFertilize;
      detail = dueText(l10n, plant.fertilizeDueInDays);
      buttonLabel = l10n.nextUpFeedNow;
      variant = AppButtonVariant.orange;
      onPressed = () => CareActions.fertilize(context, c, plant);
    } else {
      final d = plant.waterDueInDays;
      icon = Icons.check_circle_outline;
      color = const Color(0xFF43A047);
      headline = l10n.nextUpAllDone;
      detail = d == null
          ? l10n.dueNotSet
          : l10n.nextUpNextWater(dayLabel(l10n, plant.nextWatering!, d));
      buttonLabel = l10n.nextUpWaterEarly;
      variant = AppButtonVariant.outline;
      onPressed = () => CareActions.water(context, c, plant);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nextUpTitle,
            style: AppTextStyles.inter(
              12,
              w: FontWeight.w700,
              c: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: AppTextStyles.inter(
                        17,
                        w: FontWeight.w700,
                        c: AppColors.greenPrimary,
                      ),
                    ),
                    Text(
                      detail,
                      style: AppTextStyles.inter(
                        13,
                        w: FontWeight.w600,
                        c: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppButton(
            label: buttonLabel,
            variant: variant,
            expand: true,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
