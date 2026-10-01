import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/net_image.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/history_entry.dart';

class PlantHistoryScreen extends ConsumerStatefulWidget {
  const PlantHistoryScreen({super.key});

  @override
  ConsumerState<PlantHistoryScreen> createState() =>
      _PlantHistoryScreenState();
}

class _PlantHistoryScreenState
    extends ConsumerState<PlantHistoryScreen> {
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
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 32,
              ),
              itemCount: history.length,
              itemBuilder: (_, i) {
                final e = history[i];
                final scan = e.action == HistoryAction.scan;
                final color = scan
                    ? AppColors.greenPrimary
                    : AppColors.waterBlue;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 36,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: color,
                              child: Icon(
                                scan
                                    ? Icons.eco
                                    : Icons.water_drop,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            if (i != history.length - 1)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  margin:
                                      const EdgeInsets.symmetric(
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
                          margin: const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding: const EdgeInsets.all(12),
                          radius: 18,
                          onTap: () => context.push(
                            '/plants/${e.plant.id}',
                          ),
                          child: Row(
                            children: [
                              NetImage(
                                e.plant.imageUrl,
                                width: 52,
                                height: 52,
                                radius: 14,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scan
                                          ? l10n.historyScanEntry(
                                              e.plant.nickname,
                                            )
                                          : l10n.historyWateredEntry(
                                              e.plant.nickname,
                                            ),
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