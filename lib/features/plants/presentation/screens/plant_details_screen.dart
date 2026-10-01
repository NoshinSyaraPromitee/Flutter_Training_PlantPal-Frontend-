import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../widgets/health_badge.dart';
import '../widgets/plant_details_header.dart';
import '../widgets/plant_stat_tiles.dart';

class PlantDetailsScreen extends ConsumerWidget {
  const PlantDetailsScreen({
    super.key,
    required this.plantId,
  });

  final String plantId;

  Future<void> _onMenu(
    BuildContext context,
    WidgetRef ref,
    String action,
    Plant plant,
  ) async {
    final c = ref.read(plantsControllerProvider);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final l10n = AppLocalizations.of(context);

    if (action == 'fertilize') {
      final err = await c.markFertilized(plant.id);

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            err ?? l10n.plantFertilizedSnackbar(plant.nickname),
          ),
        ),
      );
      return;
    }

    if (action == 'water') {
      final err = await c.markWatered(plant.id);

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            err ?? l10n.plantWateredSnackbar(plant.nickname),
          ),
        ),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deletePlantConfirmTitle),
        content: Text(
          l10n.deletePlantConfirmBody(plant.nickname),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final err = await c.remove(plant.id);

    if (err != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(err)),
      );
    } else if (router.canPop()) {
      router.pop();
    } else {
      router.go('/plants');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plant = ref.watch(plantsControllerProvider).byId(plantId);

    if (plant == null) {
      return AppScreen(
        title: l10n.plantFallbackTitle,
        child: ErrorView(
          message: l10n.plantNotFoundMessage,
        ),
      );
    }

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PlantDetailsHeader(
                imageUrl: plant.imageUrl,
                onBack: () =>
                    context.canPop() ? context.pop() : context.go('/plants'),
                onMenuSelected: (v) =>
                    _onMenu(context, ref, v, plant),
                waterLabel: l10n.markAsWateredTooltip,
                fertilizeLabel: l10n.markAsFertilizedTooltip,
                deleteLabel: l10n.deletePlantMenuItem,
              ),
              Container(
                transform: Matrix4.translationValues(0, -28, 0),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  80,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.nickname,
                      style: AppTextStyles.screenTitle,
                    ),
                    Text(
                      plant.species,
                      style: AppTextStyles.inter(
                        16,
                        c: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HealthBadge(health: plant.health),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        PlantStatTile(
                          icon: Icons.water_drop,
                          color: AppColors.waterBlue,
                          title: l10n.careMetricWater,
                          value: plant.waterLevel,
                        ),
                        PlantStatTile(
                          icon: Icons.wb_sunny,
                          color: AppColors.sunAmber,
                          title: l10n.careMetricSunlight,
                          value: plant.sunlight,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        PlantStatTile(
                          icon: Icons.location_on,
                          color: AppColors.greenPrimary,
                          title: l10n.locationLabel,
                          value: plant.location,
                        ),
                        PlantStatTile(
                          icon: Icons.opacity,
                          color: const Color(0xFF00ACC1),
                          title: l10n.careMetricHumidity,
                          value: plant.humidity,
                        ),
                      ],
                    ),
                    SectionTitle(l10n.todaysCareTitle),
                    PlantTaskRow(
                      icon: Icons.check_circle,
                      color: const Color(0xFF4CAF50),
                      text: l10n.plantWaterLevelLabel(
                        plant.waterLevel,
                      ),
                    ),
                    PlantTaskRow(
                      icon: Icons.local_florist,
                      color: const Color(0xFFFB8C00),
                      text: plant.fertilizerNote.isEmpty
                          ? l10n.noFertilizerNoteMessage
                          : l10n.plantFertilizeNoteLabel(
                              plant.fertilizerNote,
                            ),
                    ),
                    PlantTaskRow(
                      icon: Icons.photo_camera_outlined,
                      color: const Color(0xFF5C6BC0),
                      text: l10n.plantLastScanLabel(
                        relativeDay(plant.lastScan),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l10n.scanAgainButton,
                        trailingIcon: Icons.photo_camera,
                        onPressed: () => context.push(
                          '/plants/${plant.id}/scan',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l10n.askAiDoctorButton,
                        variant: AppButtonVariant.orange,
                        trailingIcon: Icons.smart_toy,
                        onPressed: () =>
                            context.go('/ai-doctor'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l10n.viewCareGuideButton,
                        trailingIcon: Icons.eco,
                        onPressed: () => context.push(
                          '/care-guide?plantId=${plant.id}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}