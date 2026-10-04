import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/plant_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../providers/plants_provider.dart';
import '../utils/care_actions.dart';
import '../utils/due_text.dart';
import 'health_ring.dart';

/// One plant in My Plants: photo inside a health ring, name, one status line
/// and a one-tap water button. Swipe right = water, swipe left = fertilize.
class PlantStatusCard extends ConsumerWidget {
  const PlantStatusCard({super.key, required this.plant});

  final Plant plant;

  static const _amber = Color(0xFFB77900);

  /// Icon, colour and text of the single status line.
  (IconData, Color, String) _status(
    AppLocalizations l10n, {
    required bool pending,
  }) {
    if (pending) {
      return (Icons.check_circle, const Color(0xFF43A047), l10n.statusWatered);
    }
    final d = plant.waterDueInDays;
    if (d == null) {
      return (Icons.water_drop_outlined, AppColors.textMuted, l10n.dueNotSet);
    }
    if (d < 0) {
      return (
        Icons.warning_amber_rounded,
        AppColors.danger,
        l10n.dueOverdueDays(-d),
      );
    }
    if (d == 0) {
      return (Icons.water_drop, AppColors.waterBlue, l10n.statusWaterToday);
    }
    if (plant.isFertilizeDue) {
      return (Icons.eco, _amber, l10n.statusFeedDue);
    }
    return (
      Icons.event_outlined,
      AppColors.textMuted,
      l10n.statusNextWater(dayLabel(l10n, plant.nextWatering!, d)),
    );
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) =>
      Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.inter(
                11,
                w: FontWeight.w700,
                c: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _waterButton(
    AppLocalizations l10n,
    PlantsController c, {
    required bool pending,
    required BuildContext context,
  }) {
    final tooltip = l10n.waterPlantTooltip(plant.nickname);
    if (pending) {
      return IconButton.filled(
        tooltip: tooltip,
        onPressed: null,
        icon: const Icon(Icons.check),
        style: IconButton.styleFrom(
          disabledBackgroundColor: const Color(0xFF43A047),
          disabledForegroundColor: Colors.white,
        ),
      );
    }
    void onTap() => CareActions.water(context, c, plant);
    if (plant.isWaterDue) {
      return IconButton.filled(
        tooltip: tooltip,
        onPressed: onTap,
        icon: const Icon(Icons.water_drop),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.waterBlue,
          foregroundColor: Colors.white,
        ),
      );
    }
    return IconButton.outlined(
      tooltip: tooltip,
      onPressed: onTap,
      icon: const Icon(Icons.water_drop_outlined),
      style: IconButton.styleFrom(
        foregroundColor: AppColors.waterBlue,
        side: const BorderSide(color: AppColors.waterBlue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = ref.watch(plantsControllerProvider);
    final pending = c.isWaterPending(plant.id);
    final (statusIcon, statusColor, statusText) = _status(
      l10n,
      pending: pending,
    );
    final sub = plant.location.trim().isEmpty
        ? plant.species
        : '${plant.species} · ${plant.location.trim()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Dismissible(
        key: ValueKey('plant-card-${plant.id}'),
        background: _swipeBackground(
          color: AppColors.waterBlue,
          icon: Icons.water_drop,
          label: l10n.markAsWateredTooltip,
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _swipeBackground(
          color: _amber,
          icon: Icons.eco,
          label: l10n.markAsFertilizedTooltip,
          alignment: Alignment.centerRight,
        ),
        // The card never leaves the list: swiping only triggers the action.
        confirmDismiss: (dir) async {
          if (dir == DismissDirection.startToEnd) {
            CareActions.water(context, c, plant);
          } else {
            CareActions.fertilize(context, c, plant);
          }
          return false;
        },
        child: AppCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
          radius: 22,
          onTap: () => context.push('/plants/${plant.id}'),
          child: Row(
            children: [
              HealthRing(
                health: plant.health,
                state: plant.healthState,
                size: 82,
                child: ClipOval(
                  child: PlantImage(
                    plant.imageUrl,
                    width: 68,
                    height: 68,
                    radius: 34,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.inter(
                        18,
                        w: FontWeight.w700,
                        c: AppColors.greenPrimary,
                      ),
                    ),
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.inter(
                        12,
                        c: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.inter(
                              13,
                              w: FontWeight.w700,
                              c: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _waterButton(l10n, c, pending: pending, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
