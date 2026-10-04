import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/care_task.dart';
import '../utils/due_text.dart';

class CareCalendarScreen extends ConsumerStatefulWidget {
  const CareCalendarScreen({super.key});

  @override
  ConsumerState<CareCalendarScreen> createState() =>
      _CareCalendarScreenState();
}

class _CareCalendarScreenState
    extends ConsumerState<CareCalendarScreen> {
  /// Tasks whose API call is in flight.
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(plantsControllerProvider).load(),
    );
  }

  /// Tapping a due task logs it through the watering / fertilizing API. The
  /// plant then comes back with its next date moved forward, so the task
  /// leaves "Today" by itself.
  Future<void> _complete(CareTask t) async {
    if (_busy.contains(t.id)) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final c = ref.read(plantsControllerProvider);
    final isWater = t.type == CareTaskType.water;
    final name = t.plant.nickname;

    setState(() => _busy.add(t.id));
    final err = isWater
        ? await c.markWatered(t.plant.id)
        : await c.markFertilized(t.plant.id);
    if (!mounted) return;
    setState(() => _busy.remove(t.id));

    final base = isWater
        ? l10n.plantWateredSnackbar(name)
        : l10n.plantFertilizedSnackbar(name);
    final points = c.lastActionPointsEarned;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          err ?? (points > 0 ? '$base  ${l10n.pointsEarned(points)}' : base),
        ),
      ),
    );
  }

  Widget _trailing(CareTask t, AppLocalizations l10n) {
    if (_busy.contains(t.id)) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (t.group == CareTaskGroup.today) {
      return const Icon(
        Icons.radio_button_unchecked,
        color: AppColors.greenPrimary,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final titles = {
      CareTaskGroup.today: l10n.todayLabel,
      CareTaskGroup.tomorrow: l10n.tomorrowLabel,
      CareTaskGroup.later: l10n.laterThisWeekLabel,
    };

    final tasks = ref.watch(plantsControllerProvider).careTasks;
    final nothingDue = tasks.isNotEmpty &&
        !tasks.any((t) => t.group == CareTaskGroup.today);

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
                if (nothingDue)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EmptyView(
                      icon: Icons.verified,
                      title: l10n.allCaughtUpTitle,
                      subtitle: l10n.allCaughtUpBody,
                    ),
                  ),
                for (final g in CareTaskGroup.values)
                  if (tasks.any((t) => t.group == g)) ...[
                    SectionTitle(titles[g]!.toUpperCase()),
                    for (final t in tasks.where((t) => t.group == g))
                      AppCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        onTap: t.group == CareTaskGroup.today
                            ? () => _complete(t)
                            : null,
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
                                  if (t.days < 0)
                                    Text(
                                      dueText(l10n, t.days),
                                      style: AppTextStyles.inter(
                                        12,
                                        w: FontWeight.w600,
                                        c: AppColors.danger,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            _trailing(t, l10n),
                          ],
                        ),
                      ),
                  ],
              ],
            ),
    );
  }
}
