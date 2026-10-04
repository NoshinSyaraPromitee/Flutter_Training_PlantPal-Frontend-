import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';

/// One small chip per reason the health score is below 100. The server sends
/// reason codes only; the text is localised here.
class HealthReasonChips extends StatelessWidget {
  const HealthReasonChips({super.key, required this.reasons});

  final List<HealthReason> reasons;

  static String _severity(AppLocalizations l10n, String s) => switch (s) {
        'mild' => l10n.scanSeverityMild,
        'moderate' => l10n.scanSeverityModerate,
        'severe' => l10n.scanSeveritySevere,
        _ => s,
      };

  /// Icon + localised text for one reason (null for unknown codes).
  static (IconData, String)? content(AppLocalizations l10n, HealthReason r) =>
      switch (r.code) {
        HealthReason.waterLate => (
            Icons.water_drop,
            l10n.healthReasonWaterLate(r.value ?? 0),
          ),
        HealthReason.fertilizerLate => (
            Icons.eco,
            l10n.healthReasonFertilizerLate(r.value ?? 0),
          ),
        HealthReason.scanIssue => (
            Icons.photo_camera_outlined,
            l10n.healthReasonScanIssue(
              r.detail,
              _severity(l10n, r.severity),
            ),
          ),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = <Widget>[];

    for (final r in reasons) {
      final c = content(l10n, r);
      if (c == null) continue;
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(c.$1, size: 14, color: const Color(0xFFC62828)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  c.$2,
                  style: AppTextStyles.inter(
                    12,
                    w: FontWeight.w600,
                    c: const Color(0xFFC62828),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}
