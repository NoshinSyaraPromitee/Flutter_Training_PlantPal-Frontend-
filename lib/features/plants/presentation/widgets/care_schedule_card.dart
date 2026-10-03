import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../utils/due_text.dart';

/// Water and Fertilize rows: last done, next due, interval and a countdown
/// bar that fills as the due date gets closer.
class CareScheduleCard extends StatelessWidget {
  const CareScheduleCard({
    super.key,
    required this.plant,
    required this.onWater,
    required this.onFertilize,
  });

  final Plant plant;
  final VoidCallback onWater;
  final VoidCallback onFertilize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _ScheduleRow(
          icon: Icons.water_drop,
          color: AppColors.waterBlue,
          title: l10n.scheduleWater,
          last: plant.lastWatered,
          next: plant.nextWatering,
          intervalDays: plant.wateringFrequencyDays,
          actionIcon: Icons.water_drop_outlined,
          onAction: onWater,
        ),
        _ScheduleRow(
          icon: Icons.eco,
          color: const Color(0xFFB77900),
          title: l10n.scheduleFertilize,
          last: plant.lastFertilized,
          next: plant.nextFertilizing,
          intervalDays: plant.fertilizeIntervalDays,
          note: plant.fertilizerNote,
          actionIcon: Icons.check,
          onAction: onFertilize,
        ),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.last,
    required this.next,
    required this.intervalDays,
    required this.actionIcon,
    required this.onAction,
    this.note = '',
  });

  final IconData icon;
  final Color color;
  final String title;
  final DateTime? last, next;
  final int intervalDays;
  final String note;
  final IconData actionIcon;
  final VoidCallback onAction;

  /// 0 = just done, 1 = due (or overdue).
  double _progress(int? days) {
    if (days == null) return 0;
    if (days <= 0) return 1;
    final total = intervalDays > 0 ? intervalDays : 7;
    return (1 - days / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = next == null ? null : calendarDaysUntil(next!);
    final barColor = days == null
        ? AppColors.textMuted
        : days < 0
            ? AppColors.danger
            : days == 0
                ? const Color(0xFFFB8C00)
                : color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.inter(
                    15,
                    w: FontWeight.w700,
                    c: AppColors.greenPrimary,
                  ),
                ),
              ),
              if (intervalDays > 0)
                Text(
                  l10n.scheduleEvery(intervalDays),
                  style: AppTextStyles.inter(
                    12,
                    w: FontWeight.w600,
                    c: AppColors.textMuted,
                  ),
                ),
              IconButton(
                tooltip: title,
                visualDensity: VisualDensity.compact,
                icon: Icon(actionIcon, color: color),
                onPressed: onAction,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.scheduleLast(agoText(l10n, last)),
                        style: AppTextStyles.inter(13, c: Colors.black54),
                      ),
                    ),
                    Text(
                      l10n.scheduleNext(dueText(l10n, days)),
                      style: AppTextStyles.inter(
                        13,
                        w: FontWeight.w700,
                        c: barColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _progress(days),
                    minHeight: 8,
                    color: barColor,
                    backgroundColor: barColor.withValues(alpha: 0.15),
                  ),
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    note,
                    style: AppTextStyles.inter(12, c: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
