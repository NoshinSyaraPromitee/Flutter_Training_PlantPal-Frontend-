import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import 'health_reason_chips.dart';
import 'health_ring.dart';

/// Bottom sheet that explains the health score: 100 minus each reason.
Future<void> showHealthBreakdown(BuildContext context, Plant plant) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _HealthBreakdown(plant: plant),
  );
}

class _HealthBreakdown extends StatelessWidget {
  const _HealthBreakdown({required this.plant});

  final Plant plant;

  Widget _line(String text, String value, {IconData? icon, Color? color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon ?? Icons.circle, size: icon == null ? 8 : 18, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.inter(14, w: FontWeight.w600),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.inter(
                14,
                w: FontWeight.w700,
                c: color,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = healthColor(plant.healthState);
    final rows = <Widget>[];
    for (final r in plant.healthReasons) {
      final c = HealthReasonChips.content(l10n, r);
      if (c == null) continue;
      rows.add(
        _line(c.$2, '${r.impact}', icon: c.$1, color: const Color(0xFFC62828)),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthBreakdownTitle,
              style: AppTextStyles.inter(
                18,
                w: FontWeight.w700,
                c: AppColors.greenPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _line(l10n.healthBreakdownBase, '100', color: color),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.healthBreakdownNoIssues,
                  style: AppTextStyles.inter(13, c: AppColors.textMuted),
                ),
              )
            else
              ...rows,
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.healthBreakdownTotal,
                    style: AppTextStyles.inter(15, w: FontWeight.w700),
                  ),
                ),
                Text(
                  '${plant.health}',
                  style: AppTextStyles.inter(
                    20,
                    w: FontWeight.w800,
                    c: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
