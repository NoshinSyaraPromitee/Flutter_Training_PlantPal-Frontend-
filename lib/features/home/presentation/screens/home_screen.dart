import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/curved_header.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/greeting.dart';
import '../providers/greeting_providers.dart';
import '../widgets/chat_avatar.dart';
import '../widgets/points_badge.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/speech_bubble.dart';

/// Main menu / dashboard screen shown after the splash screen.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final greeting = ref.watch(greetingMessageProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CurvedHeader(
              title: l10n.homeHeaderTitle,
              subtitle: l10n.homeHeaderSubtitle,
              corner: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [PointsBadge(), SizedBox(width: AppSpacing.sm), LanguageSwitcher()],
              ),
              trailing: AppButton(
                label: l10n.uploadPlantPhoto,
                trailingIcon: Icons.add_circle_outline,
                variant: AppButtonVariant.secondary,
                expand: true,
                onPressed: () => context.push('/scan'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: Image.asset(
                          'assets/images/splash_mascot.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SpeechBubble(
                          text: _greetingText(l10n, greeting),
                          onTap: () => context.push('/plants'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('QUICK ACTIONS', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: AppSpacing.md),
                  const QuickActionsGrid(),
                  const SizedBox(height: AppSpacing.xxl),
                  ChatAvatar(onTap: () => context.go('/ai-doctor')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _greetingText(AppLocalizations l10n, Greeting greeting) {
  switch (greeting.kind) {
    case GreetingKind.morning:
      return l10n.greetingMorning;
    case GreetingKind.afternoon:
      return l10n.greetingAfternoon;
    case GreetingKind.evening:
      return l10n.greetingEvening;
    case GreetingKind.night:
      return l10n.greetingNight;
    case GreetingKind.plantThirsty:
      return l10n.greetingPlantThirsty;
    case GreetingKind.weatherRain:
      return l10n.greetingWeatherRain;
    case GreetingKind.weatherThunderstorm:
      return l10n.greetingWeatherThunderstorm;
    case GreetingKind.weatherSnow:
      return l10n.greetingWeatherSnow;
    case GreetingKind.weatherFog:
      return l10n.greetingWeatherFog;
    case GreetingKind.weatherHot:
      return l10n.greetingWeatherHot(greeting.temperatureC!);
  }
}
