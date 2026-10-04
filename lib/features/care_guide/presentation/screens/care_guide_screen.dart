import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../domain/model/care_guide.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/riverpod_providers.dart';

class CareGuideScreen extends ConsumerStatefulWidget {
  const CareGuideScreen({super.key, this.plantId});

  final String? plantId;

  @override
  ConsumerState<CareGuideScreen> createState() => _CareGuideScreenState();
}

class _CareGuideScreenState extends ConsumerState<CareGuideScreen> {
  final _done = <int>{};

  IconData _taskIcon(DailyTaskKind k) => switch (k) {
        DailyTaskKind.moisture => Icons.water_drop_outlined,
        DailyTaskKind.light => Icons.wb_sunny_outlined,
        DailyTaskKind.mist => Icons.water,
        DailyTaskKind.dust => Icons.cleaning_services,
        DailyTaskKind.pests => Icons.search,
      };

  (IconData, Color) _problemStyle(ProblemKind k) => switch (k) {
        ProblemKind.yellowLeaves =>
          (Icons.error_outline, const Color(0xFFE53935)),
        ProblemKind.brownTips =>
          (Icons.local_fire_department, const Color(0xFFFB8C00)),
        ProblemKind.drooping =>
          (Icons.arrow_circle_down, const Color(0xFF5C6BC0)),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plant = widget.plantId == null
        ? null
        : ref.watch(plantsControllerProvider).byId(widget.plantId!);
    final g = ref.read(careGuideRepositoryProvider).guideFor(plant);
    final total = g.dailyTasks.length;
    final cardWidth = (MediaQuery.of(context).size.width - 52) / 2;

    final essentials = <(IconData, Color, String, String)>[
      (Icons.water_drop, AppColors.waterBlue, l10n.careMetricWater, g.water),
      (Icons.wb_sunny, AppColors.sunAmber, l10n.careMetricSunlight, g.sunlight),
      (Icons.thermostat, AppColors.danger, l10n.careMetricTemp, g.temperature),
      (Icons.eco, const Color(0xFF43A047), l10n.careMetricFertilizer, g.fertilizer),
      (Icons.opacity, const Color(0xFF00ACC1), l10n.careMetricHumidity, g.humidity),
    ];

    return AppScreen(
      title: l10n.careGuideTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter(24, w: FontWeight.w800, c: Colors.white)),
                const SizedBox(height: 4),
                Text(g.species, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter(14, c: Colors.white70)),
              ],
            ),
          ),
          SectionTitle(
            l10n.careChallengeTitle,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_done.length}/$total',
                style: AppTextStyles.inter(12, w: FontWeight.w700, c: AppColors.greenPrimary),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : _done.length / total,
              minHeight: 8,
              color: AppColors.greenPrimary,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                for (var i = 0; i < total; i++)
                  InkWell(
                    onTap: () => setState(() =>
                        _done.contains(i) ? _done.remove(i) : _done.add(i)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            _done.contains(i)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _done.contains(i)
                                ? AppColors.greenPrimary
                                : Colors.black38,
                          ),
                          const SizedBox(width: 10),
                          Icon(_taskIcon(g.dailyTasks[i].kind), size: 18,
                              color: _done.contains(i)
                                  ? Colors.black26
                                  : AppColors.greenPrimary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              g.dailyTasks[i].label,
                              style: AppTextStyles.inter(
                                14,
                                c: _done.contains(i)
                                    ? Colors.black38
                                    : AppColors.textDark,
                              ).copyWith(
                                decoration: _done.contains(i)
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_done.length == total && total > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.celebration, size: 18,
                            color: AppColors.greenPrimary),
                        const SizedBox(width: 8),
                        Text(
                          l10n.careChallengeDoneMessage,
                          style: AppTextStyles.inter(
                            13,
                            w: FontWeight.w600,
                            c: AppColors.greenPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SectionTitle(l10n.careEssentialsTitle),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final e in essentials)
                SizedBox(
                  width: cardWidth,
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: e.$2.withValues(alpha: 0.12),
                          child: Icon(e.$1, size: 20, color: e.$2),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.$3,
                                  style: AppTextStyles.inter(12, c: AppColors.textMuted)),
                              Text(e.$4, maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.inter(13, w: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SectionTitle(l10n.careProTipsTitle),
          AppCard(
            child: Column(
              children: [
                for (var i = 0; i < g.proTips.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: AppColors.greenPrimary,
                          child: Text('${i + 1}',
                              style: AppTextStyles.inter(11,
                                  w: FontWeight.w700, c: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(g.proTips[i],
                            style: AppTextStyles.inter(13, h: 1.4))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SectionTitle(l10n.careCommonProblemsTitle),
          for (final p in g.problems)
            AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        _problemStyle(p.kind).$2.withValues(alpha: 0.12),
                    child: Icon(
                      _problemStyle(p.kind).$1,
                      color: _problemStyle(p.kind).$2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title,
                            style: AppTextStyles.inter(14, w: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(p.fix,
                            style: AppTextStyles.inter(
                                12, c: AppColors.textMuted, h: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

