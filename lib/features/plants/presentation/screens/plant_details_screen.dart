import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../../../ai_doctor/domain/model/chat_models.dart';
import '../utils/care_actions.dart';
import '../utils/plant_choices.dart';
import '../widgets/care_schedule_card.dart';
import '../widgets/health_badge.dart';
import '../widgets/health_breakdown_sheet.dart';
import '../widgets/health_reason_chips.dart';
import '../widgets/health_ring.dart';
import '../widgets/info_box.dart';
import '../widgets/last_scan_card.dart';
import '../widgets/next_up_card.dart';
import '../widgets/plant_details_header.dart';
import '../widgets/plant_event_timeline.dart';
import '../widgets/weather_tip_card.dart';

class PlantDetailsScreen extends ConsumerWidget {
  const PlantDetailsScreen({super.key, required this.plantId});

  final String plantId;

  /// English water status for the AI chat context ("due today", ...).
  static String _waterStatus(Plant p) {
    final d = p.waterDueInDays;
    if (d == null) return '';
    if (d < 0) return 'overdue by ${-d} days';
    if (d == 0) return 'due today';
    if (d == 1) return 'due tomorrow';
    return 'due in $d days';
  }

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

    if (action == 'edit') {
      context.push('/plants/${plant.id}/edit');
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deletePlantConfirmTitle),
        content: Text(l10n.deletePlantConfirmBody(plant.nickname)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final err = await c.remove(plant.id);

    if (err != null) {
      messenger.showSnackBar(SnackBar(content: Text(err)));
    } else if (router.canPop()) {
      router.pop();
    } else {
      router.go('/plants');
    }
  }

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(
      text,
      style: AppTextStyles.inter(
        17,
        w: FontWeight.w700,
        c: AppColors.greenPrimary,
      ),
    ),
  );

  /// Name, species, health ring and reasons. Tapping the health part opens
  /// the score breakdown.
  Widget _hero(BuildContext context, AppLocalizations l10n, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.nickname, style: AppTextStyles.screenTitle),
                  Text(
                    plant.species,
                    style: AppTextStyles.inter(16, c: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () => showHealthBreakdown(context, plant),
              child: HealthRing(
                health: plant.health,
                state: plant.healthState,
                size: 76,
                stroke: 6,
                child: Text(
                  '${plant.health}',
                  style: AppTextStyles.inter(
                    22,
                    w: FontWeight.w800,
                    c: healthColor(plant.healthState),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => showHealthBreakdown(context, plant),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealthBadge(health: plant.health, state: plant.healthState),
              if (plant.healthReasons.isNotEmpty) ...[
                const SizedBox(height: 10),
                HealthReasonChips(reasons: plant.healthReasons),
              ],
              if (plant.lastScan == null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.noCheckupHint,
                  style: AppTextStyles.inter(13, c: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Sunlight, location and humidity as one compact row; blanks are hidden.
  Widget _environment(AppLocalizations l10n, Plant plant) {
    final items = <(IconData, Color, String)>[
      if (plant.sunlight.isNotEmpty)
        (
          Icons.wb_sunny,
          AppColors.sunAmber,
          PlantChoices.label(l10n, plant.sunlight),
        ),
      if (plant.location.isNotEmpty)
        (
          Icons.location_on,
          AppColors.greenPrimary,
          PlantChoices.label(l10n, plant.location),
        ),
      if (plant.humidity.isNotEmpty)
        (Icons.opacity, const Color(0xFF00ACC1), plant.humidity),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final i in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(i.$1, size: 16, color: i.$2),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    i.$3,
                    style: AppTextStyles.inter(13, w: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// One AI Doctor button; the sheet offers the scan or the chat.
  Future<void> _aiDoctorSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Plant plant,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.scanAgainButton),
              onTap: () {
                Navigator.pop(sheetContext);
                context.push('/plants/${plant.id}/scan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy),
              title: Text(l10n.askAiDoctorButton),
              onTap: () async {
                Navigator.pop(sheetContext);
                final plantName = plant.nickname.isNotEmpty
                    ? plant.nickname
                    : plant.species;
                final seed = ChatSeed.fromPlant(
                  plantId: plant.id,
                  nickname: plant.nickname,
                  species: plant.species,
                  imageUrl: plant.imageUrl,
                  location: plant.location,
                  sunlight: plant.sunlight,
                  waterStatus: _waterStatus(plant),
                  health: plant.health,
                );
                await ref
                    .read(chatControllerProvider)
                    .startFromPlant(
                      seed,
                      prefill:
                          "Can you give me care tips for my $plantName? How can I keep it healthy?",
                    );
                if (context.mounted) context.go('/ai-doctor');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plantsController = ref.watch(plantsControllerProvider);
    final plant = plantsController.byId(plantId);

    if (plant == null) {
      return AppScreen(
        title: l10n.plantFallbackTitle,
        child: ErrorView(message: l10n.plantNotFoundMessage),
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
                onMenuSelected: (v) => _onMenu(context, ref, v, plant),
                editLabel: l10n.editPlantButton,
                deleteLabel: l10n.deletePlantMenuItem,
              ),
              Container(
                transform: Matrix4.translationValues(0, -28, 0),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _hero(context, l10n, plant),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_outlined,
                            size: 19,
                            color: Color(0xFFE47B32),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            l10n.careStreakLabel,
                            style: AppTextStyles.inter(
                              13,
                              w: FontWeight.w600,
                              c: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.careStreakDays(
                              plantsController.wateringStreak,
                            ),
                            style: AppTextStyles.inter(
                              13,
                              w: FontWeight.w700,
                              c: AppColors.greenPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    NextUpCard(plant: plant),
                    WeatherTipCard(plant: plant),
                    _title(l10n.scheduleTitle),
                    CareScheduleCard(
                      plant: plant,
                      onWater: () => CareActions.water(
                        context,
                        ref.read(plantsControllerProvider),
                        plant,
                      ),
                      onFertilize: () => CareActions.fertilize(
                        context,
                        ref.read(plantsControllerProvider),
                        plant,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => CareActions.skip(
                          context,
                          ref.read(plantsControllerProvider),
                          plant,
                        ),
                        icon: const Icon(Icons.snooze, size: 18),
                        label: Text(l10n.skipSnoozeTitle),
                      ),
                    ),
                    _environment(l10n, plant),
                    LastScanCard(plant: plant),
                    _title(l10n.plantRecentActivityTitle),
                    PlantEventTimeline(plantId: plant.id),
                    if (plant.careTips.isNotEmpty) ...[
                      _title(l10n.careTipsTitle),
                      InfoBox(
                        icon: Icons.lightbulb_outline,
                        text: plant.careTips,
                        color: AppColors.sunAmber,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () =>
                              context.push('/care-guide?plantId=${plant.id}'),
                          child: Text(l10n.viewCareGuideButton),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l10n.aiDoctorButton,
                        variant: AppButtonVariant.secondary,
                        trailingIcon: Icons.smart_toy,
                        onPressed: () =>
                            _aiDoctorSheet(context, ref, l10n, plant),
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
