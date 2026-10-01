import 'package:flutter/material.dart';

/// Colors extracted from the PlantPal "Landing Page" reference.
/// Most fields are getters (not consts) so they can flip between a light
/// and dark palette at runtime. Toggle [isDark] (SettingsController does
/// this for you) and every screen that already reads `AppColors.xxx`
/// picks up the new palette on its next rebuild — no per-screen changes.
class AppColors {
  AppColors._();

  static bool isDark = false;

  static Color get brownHeading => isDark ? const Color(0xFFC7DE7E) : const Color(0xFF8FA23E);
  static Color get orangeAccent => isDark ? const Color(0xFFE7C173) : const Color(0xFF6B5300);

  // Kept as a plain const: it's used inside `const` widgets in ~30 places,
  // so it stays the same brand-green accent in both themes.
  static const Color greenPrimary = Color(0xFF3F7D52);

  static Color get greenCardFill => isDark ? const Color(0xFF33502E) : const Color(0xFFB0D98A);
  static Color get textDark => isDark ? const Color(0xFFEDEDED) : Colors.black;

  static const Color buttonGreen = greenPrimary;
  static Color get buttonOrange => isDark ? const Color(0xFFCE9C63) : const Color(0xFFC98A55);

  static Color get textMuted => isDark ? const Color(0xFFA9A9A9) : const Color(0xFF7A7A7A);
  static const Color danger = Color(0xFFE53935);
  static const Color star = Color(0xFFFFD54F);
  static const Color waterBlue = Color(0xFF42A5F5);
  static const Color sunAmber = Color(0xFFFFB300);
  static Color get surfaceGreen => isDark ? const Color(0xFF1C2A1C) : const Color(0xFFF1F7E0);

  static Color get pinkAccent => isDark ? const Color(0xFFE07E96) : const Color(0xFFD14562);
  static Color get potTan => isDark ? const Color(0xFF7C6547) : const Color(0xFFE6CFB4);

  static const List<double> backgroundGradientStops = [0.0296, 0.1565, 0.8416, 1.0];

  static List<Color> get backgroundGradientColors => isDark
      ? const [Color(0xFF10190F), Color(0xFF15221A), Color(0xFF182A1D), Color(0xFF0F1A11)]
      : const [Color(0xFFFFF6DC), Color(0xFFEAF7D0), Color(0xFFDCE6B7), Color(0xFFEFEAC0)];

  static LinearGradient get screenBackground => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: backgroundGradientStops,
        colors: backgroundGradientColors,
      );

  // Compatibility colors used by feature screens.
  static Color get green => greenPrimary;
  static Color get orange => orangeAccent;
  static Color get teal => const Color(0xFF2A9D8F);
  static Color get plum => const Color(0xFF7B4B7A);

  static Color get background => isDark
      ? const Color(0xFF10190F)
      : const Color(0xFFFFF6DC);

  static Color get textPrimary => textDark;
  static Color get textSecondary => textMuted;

  static Color get accentRotation => pinkAccent;
}