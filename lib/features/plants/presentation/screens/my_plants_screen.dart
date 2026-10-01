import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/plant_status_card.dart';

class MyPlantsScreen extends ConsumerStatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  ConsumerState<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends ConsumerState<MyPlantsScreen> {
  String _q = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(plantsControllerProvider).load(),
    );
  }

  Widget _stat(String value, String label) => Expanded(
        child: AppCard(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(
                value,
                style: AppTextStyles.inter(
                  22,
                  w: FontWeight.w700,
                  c: AppColors.greenPrimary,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.inter(
                  12,
                  c: AppColors.textMuted,
                ),
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

    final list = c.plants
        .where(
          (p) =>
              q.isEmpty ||
              p.nickname.toLowerCase().contains(q) ||
              p.species.toLowerCase().contains(q),
        )
        .toList();

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
                        _stat('${c.plants.length}', l10n.statPlants),
                        _stat('${c.averageHealth}%', l10n.statHealth),
                        _stat(
                          '${c.waterTodayCount}',
                          l10n.statWaterToday,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: list.isEmpty
                          ? EmptyView(
                              icon: Icons.local_florist,
                              title: l10n.noPlantsTitle,
                              subtitle: l10n.noPlantsBody,
                            )
                          : RefreshIndicator(
                              onRefresh: () => c.load(force: true),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 24),
                                itemCount: list.length,
                                itemBuilder: (_, i) =>
                                    PlantStatusCard(plant: list[i]),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}