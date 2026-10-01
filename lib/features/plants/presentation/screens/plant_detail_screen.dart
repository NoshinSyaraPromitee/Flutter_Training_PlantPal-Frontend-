import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/model/plant.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/riverpod_providers.dart';

class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plant = ref.watch(plantsControllerProvider).byId(id);
    if (plant == null) {
      return AppScreen(title: l10n.plantDetailsTitle, child: ErrorView(message: l10n.plantNotFoundMessage));
    }

    return AppScreen(
      title: l10n.plantDetailsTitle,
      child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
        _PlantHeroCard(plant: plant),
        SectionTitle(l10n.careSummaryTitle),
        _InfoGrid(plant: plant),
        SectionTitle(l10n.actionsTitle),
        _ActionRow(plant: plant),
      ]),
    );
  }
}

class _PlantHeroCard extends StatelessWidget {
  const _PlantHeroCard({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: plant.imageUrl.isNotEmpty
              ? Image.network(plant.imageUrl, height: 200, fit: BoxFit.cover)
              : Container(
                  height: 200,
                  color: AppColors.surfaceGreen,
                  child: const Icon(Icons.local_florist, size: 80, color: AppColors.greenPrimary),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(plant.nickname.isEmpty ? l10n.noNicknameLabel : plant.nickname, style: AppTextStyles.screenTitle),
            Text(plant.species.isEmpty ? l10n.unknownSpeciesLabel : plant.species, style: AppTextStyles.inter(14, c: AppColors.textMuted)),
          ]),
        ),
      ]),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final daysSince = plant.lastWatered != null ? now.difference(plant.lastWatered!).inDays : null;
    final String waterStatus = daysSince == null
        ? l10n.neverWateredLabel
        : daysSince == 0
            ? l10n.wateredTodayLabel
            : l10n.daysAgoLabel(daysSince);
    final daysUntilNext = plant.lastWatered != null
        ? plant.wateringFrequencyDays - now.difference(plant.lastWatered!).inDays
        : 0;
    final nextWater = daysUntilNext <= 0 ? l10n.waterNowLabel : l10n.daysLeftLabel(daysUntilNext);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Chip(Icons.water_drop, AppColors.waterBlue, l10n.lastWateredLabel, waterStatus),
        _Chip(Icons.event_repeat, AppColors.greenPrimary, l10n.nextWaterLabel, nextWater),
        _Chip(Icons.wb_sunny_outlined, const Color(0xFFFB8C00), l10n.sunlightLabel, plant.sunlight.isEmpty ? '—' : plant.sunlight),
        _Chip(Icons.location_on_outlined, AppColors.danger, l10n.locationLabel, plant.location.isEmpty ? '—' : plant.location),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.color, this.label, this.value);
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 40 - 12) / 2;
    return SizedBox(
      width: w,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, size: 20, color: color)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: AppTextStyles.inter(11, c: AppColors.textMuted)),
              Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.inter(13, w: FontWeight.w700)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: AppButton(
          label: l10n.markWateredButton,
          trailingIcon: Icons.water_drop,
          onPressed: () async {
            await ref.read(plantsControllerProvider).markWatered(plant.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.markedWateredSnackbar(plant.nickname))),
              );
            }
          },
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: AppButton(
          label: l10n.viewCareGuideButton,
          variant: AppButtonVariant.orange,
          trailingIcon: Icons.auto_stories,
          onPressed: () => context.push('/care-guide?plantId=${plant.id}'),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: AppButton(
          label: l10n.editPlantButton,
          variant: AppButtonVariant.green,
          trailingIcon: Icons.edit,
          onPressed: () => context.push('/plants/${plant.id}/edit'),
        ),
      ),
    ]);
  }
}
