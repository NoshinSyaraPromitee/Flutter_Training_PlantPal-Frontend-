import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/features/home/domain/greeting.dart';
import 'package:plantpal/features/home/presentation/providers/greeting_providers.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_speech_bubble.dart';
import 'package:plantpal/features/plants/presentation/providers/plants_provider.dart';
import 'package:plantpal/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Mascot illustration + speech bubble shown at the top of the main menu.
/// The bubble text prioritizes an actionable plant-care nudge, falls back
/// to a notable weather condition, and otherwise greets by time of day.
class MainMenuMascot extends ConsumerWidget {
  const MainMenuMascot({super.key, required this.imageAsset, required this.onBubbleTap});

  final String imageAsset;
  final VoidCallback onBubbleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final waterTodayCount = context.watch<PlantsController>().waterTodayCount;
    final greeting = waterTodayCount > 0 ? const Greeting(GreetingKind.plantThirsty) : ref.watch(greetingMessageProvider);
    final bubbleText = _greetingText(t, greeting);

    return LayoutBuilder(
      builder: (context, c) {
        final bubbleLeft = c.maxWidth / 2 + 52;
        final bubbleWidth = math.min(140.0, c.maxWidth - bubbleLeft);
        return SizedBox(
          height: 132,
          child: Stack(
            children: [
              Align(
                child: Container(
                  width: 84,
                  height: 108,
                  padding: const EdgeInsets.all(4),
                  color: const Color(0xFFCFE8B8),
                  child: Image.asset(imageAsset, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                left: bubbleLeft,
                top: 0,
                width: bubbleWidth,
                child: SpeechBubble(text: bubbleText, onTap: onBubbleTap),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _greetingText(AppLocalizations t, Greeting greeting) {
  switch (greeting.kind) {
    case GreetingKind.morning:
      return t.greetingMorning;
    case GreetingKind.afternoon:
      return t.greetingAfternoon;
    case GreetingKind.evening:
      return t.greetingEvening;
    case GreetingKind.night:
      return t.greetingNight;
    case GreetingKind.plantThirsty:
      return t.greetingPlantThirsty;
    case GreetingKind.weatherRain:
      return t.greetingWeatherRain;
    case GreetingKind.weatherThunderstorm:
      return t.greetingWeatherThunderstorm;
    case GreetingKind.weatherSnow:
      return t.greetingWeatherSnow;
    case GreetingKind.weatherFog:
      return t.greetingWeatherFog;
    case GreetingKind.weatherHot:
      return t.greetingWeatherHot(greeting.temperatureC!);
  }
}
