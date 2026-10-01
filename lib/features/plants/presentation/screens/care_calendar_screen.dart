import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/care_tasks.dart';

class CareCalendarScreen extends ConsumerStatefulWidget {
  const CareCalendarScreen({super.key});

  @override
  ConsumerState<CareCalendarScreen> createState() =>
      _CareCalendarScreenState();
}

class _CareCalendarScreenState
    extends ConsumerState<CareCalendarScreen> {
  final _done = <String>{};

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

    final titles = {
      CareTaskGroup.today: l10n.todayLabel,
      CareTaskGroup.tomorrow: l10n.tomorrowLabel,
      CareTaskGroup.later: l10n.laterThisWeekLabel,
    };

    final tasks = const BuildCareTasks()(
      ref.watch(plantsControllerProvider).plants,
    );

    final allDone = tasks.isNotEmpty &&
        tasks.every((t) => _done.contains(t.id));

    return AppScreen(
      title: l10n.careCalendarTitle,
      child: tasks.isEmpty
          ? EmptyView(
              icon: Icons.event_available,
              title: l10n.noCareTasksTitle,
              subtitle: l10n.noCareTasksBody,
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                for (final g in CareTaskGroup.values)
                  if (tasks.any((t) => t.group == g)) ...[
                    SectionTitle(titles[g]!.toUpperCase()),
                    for (final t in tasks.where((t) => t.group == g))
                      AppCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        onTap: () {
                          setState(
                            () => _done.contains(t.id)
                                ? _done.remove(t.id)
                                : _done.add(t.id),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  (t.type == CareTaskType.water
                                          ? AppColors.waterBlue
                                          : const Color(0xFF8D6E63))
                                      .withValues(alpha: 0.15),
                              child: Icon(
                                t.type == CareTaskType.water
                                    ? Icons.water_drop
                                    : Icons.eco,
                                color: t.type == CareTaskType.water
                                    ? AppColors.waterBlue
                                    : const Color(0xFF8D6E63),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.type == CareTaskType.water
                                        ? l10n.careTaskWater(
                                            t.plant.nickname,
                                          )
                                        : l10n.careTaskFertilize(
                                            t.plant.nickname,
                                          ),
                                    style: AppTextStyles.inter(
                                      15,
                                      w: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${t.plant.species} • ${t.plant.location.isEmpty ? '—' : t.plant.location}',
                                    style: AppTextStyles.inter(
                                      12,
                                      c: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _done.contains(t.id)
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _done.contains(t.id)
                                  ? const Color(0xFF43A047)
                                  : Colors.black26,
                            ),
                          ],
                        ),
                      ),
                  ],
                if (allDone)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: EmptyView(
                      icon: Icons.verified,
                      title: l10n.allCaughtUpTitle,
                      subtitle: l10n.allCaughtUpBody,
                    ),
                  ),
              ],
            ),
    );
  }
}