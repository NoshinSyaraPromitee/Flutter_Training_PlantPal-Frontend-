import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_card.dart';
import 'package:plantpal/features/plants/domain/weather_tip.dart';
import 'package:plantpal/features/plants/presentation/providers/weather_tip_providers.dart';
import 'package:plantpal/l10n/app_localizations.dart';
import 'maintenance_colors.dart';

/// Default watering guidance in the absence of a per-plant amount (the
/// intake form is free-text, not tied to a specific saved plant yet).
const _baseWaterMl = 300;

/// Care tips, personalized with the plant's name and — for the second tip
/// — today's actual weather (falls back to generic advice if weather
/// isn't notable enough to warrant a specific call-out).
class MaintenanceTipsSection extends ConsumerWidget {
  const MaintenanceTipsSection({super.key, this.sectionKey, required this.plantName});

  final Key? sectionKey;
  final String plantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final name = plantName.trim().isEmpty ? 'your plant' : plantName.trim();
    final weatherTip = ref.watch(weatherTipProvider(_baseWaterMl));

    return Column(
      key: sectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Tips'),
        _tip("Keep $name in the sun for 100 minutes, it's sunny today."),
        const SizedBox(height: 10),
        _tip(weatherTip == null ? 'Water regularly and check that the topsoil is dry before the next watering.' : _weatherTipText(t, weatherTip)),
      ],
    );
  }

  Widget _tip(String text) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF3E3C8), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.sunAmber),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: AppTextStyles.inter(13, c: kMaintenanceInk, h: 1.4))),
          ],
        ),
      );
}

String _weatherTipText(AppLocalizations t, WeatherTip tip) {
  switch (tip.kind) {
    case WeatherTipKind.hot:
      return t.weatherTipHot(tip.suggestedWaterMl!);
    case WeatherTipKind.cold:
      return t.weatherTipCold;
    case WeatherTipKind.wetOutside:
      return t.weatherTipWetOutside;
  }
}
