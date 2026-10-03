import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/plant_image.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/history_entry.dart';

class PlantHistoryScreen extends ConsumerStatefulWidget {
  const PlantHistoryScreen({super.key});

  @override
  ConsumerState<PlantHistoryScreen> createState() => _PlantHistoryScreenState();
}

class _PlantHistoryScreenState extends ConsumerState<PlantHistoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(plantsControllerProvider).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final history = ref.watch(plantsControllerProvider).history;

    return AppScreen(
      title: l10n.plantHistoryTitle,
      child: history.isEmpty
          ? EmptyView(
              icon: Icons.history,
              title: l10n.noActivityTitle,
              subtitle: l10n.noActivityBody,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              itemCount: history.length,
              itemBuilder: (_, i) {
                final e = history[i];
                final (color, icon, title) = switch (e.action) {
                  HistoryAction.scan => (
                    AppColors.greenPrimary,
                    Icons.eco,
                    l10n.historyScanEntry(e.plant.nickname),
                  ),
                  HistoryAction.water => (
                    AppColors.waterBlue,
                    Icons.water_drop,
                    l10n.historyWateredEntry(e.plant.nickname),
                  ),
                  HistoryAction.fertilize => (
                    const Color(0xFFF57C00),
                    Icons.science_outlined,
                    l10n.historyFertilizedEntry(e.plant.nickname),
                  ),
                  HistoryAction.skip => (
                    const Color(0xFF607D8B),
                    Icons.snooze,
                    l10n.historySkippedEntry(e.plant.nickname),
                  ),
                  HistoryAction.note => (
                    const Color(0xFF5E35B1),
                    Icons.sticky_note_2_outlined,
                    l10n.historyNoteEntry(e.plant.nickname),
                  ),
                };

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 36,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: color,
                              child: Icon(icon, size: 16, color: Colors.white),
                            ),
                            if (i != history.length - 1)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  color: Colors.black12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppCard(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(12),
                          radius: 18,
                          onTap: () => context.push('/plants/${e.plant.id}'),
                          child: Row(
                            children: [
                              PlantImage(
                                e.plant.imageUrl,
                                width: 52,
                                height: 52,
                                radius: 14,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: AppTextStyles.inter(
                                        14,
                                        w: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      e.note,
                                      style: AppTextStyles.inter(
                                        12,
                                        c: AppColors.textMuted,
                                      ),
                                    ),
                                    Text(
                                      relativeDay(e.date),
                                      style: AppTextStyles.inter(
                                        12,
                                        w: FontWeight.w600,
                                        c: const Color(0xFF43A047),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
