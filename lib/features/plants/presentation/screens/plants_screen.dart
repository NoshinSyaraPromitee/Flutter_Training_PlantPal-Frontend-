import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/riverpod_providers.dart';

class PlantsScreen extends ConsumerWidget {
  const PlantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ctrl = ref.watch(plantsControllerProvider);

    return AppScreen(
      title: l10n.myPlantsMenuLabel,
      trailing: IconButton(
        icon: const CircleAvatar(backgroundColor: AppColors.greenPrimary, child: Icon(Icons.add, color: Colors.white)),
        tooltip: l10n.addPlantTitle,
        onPressed: () => context.push('/plants/add'),
      ),
      child: ctrl.loading
          ? const LoadingView()
          : ctrl.plants.isEmpty
              ? EmptyView(
                  icon: Icons.local_florist,
                  title: l10n.emptyPlantsTitle,
                  subtitle: l10n.emptyPlantsBody,
                  actionLabel: l10n.addFirstPlantButton,
                  onAction: () => context.push('/plants/add'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: ctrl.plants.length,
                  itemBuilder: (_, i) {
                    final p = ctrl.plants[i];
                    final now = DateTime.now();
                    final daysSince = p.lastWatered != null ? now.difference(p.lastWatered!).inDays : null;
                    final needsWater = daysSince == null || daysSince >= p.wateringFrequencyDays;
                    return AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () => context.push('/plants/${p.id}'),
                      child: Column(children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: p.imageUrl.isNotEmpty
                                ? Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity)
                                : Container(
                                    color: AppColors.surfaceGreen,
                                    child: const Center(child: Icon(Icons.local_florist, size: 64, color: AppColors.greenPrimary)),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(p.nickname, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.inter(14, w: FontWeight.w700)),
                                Text(p.species.isEmpty ? '—' : p.species, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.inter(12, c: AppColors.textMuted)),
                              ]),
                            ),
                            if (needsWater)
                              Tooltip(
                                message: l10n.needsWaterTooltip,
                                child: const Icon(Icons.water_drop, color: AppColors.waterBlue, size: 18),
                              ),
                          ]),
                        ),
                      ]),
                    );
                  },
                ),
    );
  }
}

class PlantGridHeader extends StatelessWidget {
  const PlantGridHeader({super.key, required this.hasPlants});
  final bool hasPlants;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l10n.plantsGridHeader, style: AppTextStyles.inter(16, w: FontWeight.w700)),
      if (hasPlants)
        AppButton(
          label: l10n.addPlantTitle,
          variant: AppButtonVariant.green,
          trailingIcon: Icons.add,
          onPressed: () => context.push('/plants/add'),
        ),
    ]);
  }
}
