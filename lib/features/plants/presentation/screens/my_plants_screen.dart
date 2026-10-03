import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../utils/care_actions.dart';
import '../utils/plant_sort.dart';
import '../widgets/plant_status_card.dart';

enum _PlantFilter { water, feeding, attention }

class MyPlantsScreen extends ConsumerStatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  ConsumerState<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends ConsumerState<MyPlantsScreen> {
  String _q = '';

  /// Tapping a chip filters the list; tapping it again clears the filter.
  _PlantFilter? _filter;
  bool _groupByLocation = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(plantsControllerProvider).load(),
    );
  }

  bool _matchesFilter(Plant p) => switch (_filter) {
        null => true,
        _PlantFilter.water => p.isWaterDue,
        _PlantFilter.feeding => p.isFertilizeDue,
        _PlantFilter.attention => p.needsAttention,
      };

  void _toggle(_PlantFilter f) =>
      setState(() => _filter = _filter == f ? null : f);

  Widget _chip({
    required _PlantFilter filter,
    required int count,
    required String label,
    required Color color,
  }) {
    final selected = _filter == filter;
    return Expanded(
      child: AppCard(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        color: selected ? AppColors.greenCardFill : null,
        onTap: () => _toggle(filter),
        child: Column(
          children: [
            Text(
              '$count',
              style: AppTextStyles.inter(
                22,
                w: FontWeight.w700,
                c: count > 0 ? color : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.inter(
                12,
                w: selected ? FontWeight.w700 : FontWeight.w500,
                c: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cards(AppLocalizations l10n, List<Plant> list) {
    if (!_groupByLocation) {
      return [for (final p in list) PlantStatusCard(plant: p)];
    }
    final groups = groupByLocation(list);
    // Named locations in urgency order, "no location" last.
    final names = [
      ...groups.keys.where((k) => k.isNotEmpty),
      if (groups.containsKey('')) '',
    ];
    return [
      for (final name in names) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.brownHeading,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name.isEmpty ? l10n.noLocationGroup : name,
                  style: AppTextStyles.inter(
                    15,
                    w: FontWeight.w700,
                    c: AppColors.brownHeading,
                  ),
                ),
              ),
              Text(
                '${groups[name]!.length}',
                style: AppTextStyles.inter(
                  13,
                  w: FontWeight.w600,
                  c: AppColors.brownHeading,
                ),
              ),
            ],
          ),
        ),
        for (final p in groups[name]!) PlantStatusCard(plant: p),
      ],
    ];
  }

  Widget _emptyGarden(AppLocalizations l10n) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_florist,
                size: 72,
                color: AppColors.brownHeading.withValues(alpha: 0.85),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noPlantsTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter(
                  18,
                  w: FontWeight.w700,
                  c: AppColors.brownHeading,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.emptyGardenBody,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter(
                  14,
                  c: AppColors.brownHeading,
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: l10n.scanToAddButton,
                leadingIcon: Icons.photo_camera,
                expand: true,
                onPressed: () => context.push('/plants/add?scan=1'),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: l10n.addManuallyButton,
                leadingIcon: Icons.edit_outlined,
                variant: AppButtonVariant.outline,
                expand: true,
                onPressed: () => context.push('/plants/add'),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = ref.watch(plantsControllerProvider);

    final q = _q.toLowerCase().trim();

    // Most urgent first, then narrowed by the search box and the chip filter.
    final list = sortByUrgency(c.plants)
        .where(
          (p) =>
              _matchesFilter(p) &&
              (q.isEmpty ||
                  p.nickname.toLowerCase().contains(q) ||
                  p.species.toLowerCase().contains(q)),
        )
        .toList();

    final dueCount = c.waterTodayCount;

    return AppScreen(
      title: l10n.myPlantsTitle,
      trailing: IconButton(
        icon: const CircleAvatar(
          backgroundColor: AppColors.greenPrimary,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onPressed: () => context.push('/plants/add'),
      ),
      child: c.loading && c.plants.isEmpty
          ? const LoadingView()
          : c.error != null && c.plants.isEmpty
              ? ErrorView(
                  message: c.error!,
                  onRetry: () => c.load(force: true),
                )
              : c.plants.isEmpty
                  ? _emptyGarden(l10n)
                  : Column(
                      children: [
                        const SizedBox(height: 8),
                        AppTextField(
                          hint: l10n.searchPlantsHint,
                          icon: Icons.search,
                          radius: 18,
                          onChanged: (v) => setState(() => _q = v),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _chip(
                              filter: _PlantFilter.water,
                              count: dueCount,
                              label: l10n.filterNeedsWater,
                              color: AppColors.waterBlue,
                            ),
                            _chip(
                              filter: _PlantFilter.feeding,
                              count: c.feedDueCount,
                              label: l10n.filterNeedsFeeding,
                              color: const Color(0xFFB77900),
                            ),
                            _chip(
                              filter: _PlantFilter.attention,
                              count: c.needAttentionCount,
                              label: l10n.filterNeedsAttention,
                              color: AppColors.danger,
                            ),
                          ],
                        ),
                        if (dueCount > 0) ...[
                          const SizedBox(height: 10),
                          AppButton(
                            label: l10n.waterAllDueButton(dueCount),
                            leadingIcon: Icons.water_drop,
                            variant: AppButtonVariant.secondary,
                            expand: true,
                            onPressed: () =>
                                CareActions.waterAllDue(context, c),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                l10n.plantsCountLabel(list.length),
                                style: AppTextStyles.inter(
                                  13,
                                  w: FontWeight.w600,
                                  c: AppColors.brownHeading,
                                ),
                              ),
                            ),
                            FilterChip(
                              label: Text(l10n.groupByLocation),
                              avatar: const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                              ),
                              selected: _groupByLocation,
                              onSelected: (v) =>
                                  setState(() => _groupByLocation = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: list.isEmpty
                              ? EmptyView(
                                  icon: Icons.filter_alt_off_outlined,
                                  title: l10n.noMatchingPlants,
                                )
                              : RefreshIndicator(
                                  onRefresh: () => c.load(force: true),
                                  child: ListView(
                                    padding:
                                        const EdgeInsets.only(bottom: 24),
                                    children: _cards(l10n, list),
                                  ),
                                ),
                        ),
                      ],
                    ),
    );
  }
}
