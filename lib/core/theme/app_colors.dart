import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDark = false;

  // ---- Landing palette (same values as landing_screen.dart) ----
  static const Color landingTop = Color(0xFFD4C26E);
  static const Color landingMid = Color(0xFF7F9B5B);
  static const Color landingBottom = Color(0xFF1B5A4B);
  static const Color cream = Color(0xFFFFF6DC);

  // Headings that sit directly on the gradient background -> cream.
  static Color get brownHeading => isDark ? const Color(0xFFC7DE7E) : cream;
  static Color get orangeAccent => isDark ? const Color(0xFFE7C173) : const Color(0xFF6B5300);

  // Brand accent (buttons, icons, links). Plain const: it is used inside
  // `const` widgets in ~30 places. Now the landing page's deep teal.
  static const Color greenPrimary = Color(0xFF1B5A4B);
  /// Icons/numbers that sit on cards: deep teal in light mode, light mint in dark mode.
  static Color get accent => isDark ? const Color(0xFFA8DC8C) : greenPrimary;

  static Color get greenCardFill => isDark ? const Color(0xFF33502E) : const Color(0xFFD9E4B0);
  static Color get textDark => isDark ? const Color(0xFFEDEDED) : const Color(0xFF1A3A31);

  static const Color buttonGreen = greenPrimary;
  static Color get buttonOrange => isDark ? const Color(0xFFCE9C63) : const Color(0xFFC98A55);

  static Color get textMuted => isDark ? const Color(0xFFA9A9A9) : const Color(0xFF5F7A6E);
  static const Color danger = Color(0xFFE53935);
  static const Color star = Color(0xFFFFD54F);
  static const Color waterBlue = Color(0xFF42A5F5);
  static const Color sunAmber = Color(0xFFFFB300);
  static Color get surfaceGreen => isDark ? const Color(0xFF26402F) : const Color(0xFFF6F0CC);

  static Color get pinkAccent => isDark ? const Color(0xFFE07E96) : const Color(0xFFD14562);
  static Color get potTan => isDark ? const Color(0xFF7C6547) : const Color(0xFFE6CFB4);

  // Light = the landing gradient. Dark keeps its own deep palette.
  static List<double> get backgroundGradientStops =>
      isDark ? const [0.0296, 0.1565, 0.8416, 1.0] : const [0.0, 0.45, 1.0];

  static List<Color> get backgroundGradientColors => isDark
      ? const [Color(0xFF10190F), Color(0xFF15221A), Color(0xFF182A1D), Color(0xFF0F1A11)]
      : const [landingTop, landingMid, landingBottom];

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

  // Flat light fill (also used as a text-field fill), so it stays cream.
  static Color get background => isDark
      ? const Color(0xFF10190F)
      : cream;

  static Color get textPrimary => textDark;
  static Color get textSecondary => textMuted;

  static Color get accentRotation => pinkAccent;
}

