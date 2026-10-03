import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../../domain/weather_tip.dart';
import '../providers/weather_tip_providers.dart';

/// Water amount used for the hot-day suggestion when the plant has none.
const _fallbackWaterMl = 300;

/// A weather-driven tip for one plant, from today's weather:
/// hot -> "give at least N ml", cold -> "water less", and rain -> "skip
/// watering" for outdoor plants only, with a one-tap "Skip today".
/// Shows nothing when the weather is unknown or not notable.
class WeatherTipCard extends ConsumerWidget {
  const WeatherTipCard({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final base =
        plant.waterAmountMl > 0 ? plant.waterAmountMl : _fallbackWaterMl;
    final tip = ref.watch(weatherTipProvider(base));
    if (tip == null) return const SizedBox.shrink();

    // Rain only matters for plants that stand outside.
    if (tip.kind == WeatherTipKind.wetOutside && !plant.isOutdoor) {
      return const SizedBox.shrink();
    }

    final (IconData icon, Color color, String text) = switch (tip.kind) {
      WeatherTipKind.hot => (
          Icons.wb_sunny,
          AppColors.sunAmber,
          l10n.weatherTipHot(tip.suggestedWaterMl ?? base),
        ),
      WeatherTipKind.cold => (
          Icons.ac_unit,
          AppColors.waterBlue,
          l10n.weatherTipCold,
        ),
      WeatherTipKind.wetOutside => (
          Icons.umbrella,
          AppColors.waterBlue,
          l10n.weatherRainSkipTip(plant.nickname),
        ),
    };
    final canSkip = tip.kind == WeatherTipKind.wetOutside && plant.isWaterDue;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(text, style: AppTextStyles.inter(13, h: 1.4)),
              ),
            ],
          ),
          if (canSkip)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                icon: const Icon(Icons.snooze, size: 18),
                label: Text(l10n.weatherRainSkipButton),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final err = await ref
                      .read(plantsControllerProvider)
                      .skipWatering(plant.id, reason: 'rained', days: 1);
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(err ?? l10n.skipSavedSnackbar(1)),
                      ),
                    );
                },
              ),
            ),
        ],
      ),
    );
  }
}
