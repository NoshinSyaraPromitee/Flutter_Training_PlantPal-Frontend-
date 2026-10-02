import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.greenPrimary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.greenPrimary,
          onPrimary: AppColors.cream,
          surface: AppColors.cream,
          onSurface: AppColors.textDark,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        elevatedButtonTheme: _buttonTheme,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.landingBottom,
          contentTextStyle: GoogleFonts.inter(
            color: AppColors.cream,
            fontWeight: FontWeight.w600,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141F17),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.greenPrimary, brightness: Brightness.dark),
        textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
        elevatedButtonTheme: _buttonTheme,
      );

  static ElevatedButtonThemeData get _buttonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenPrimary,
          foregroundColor: AppColors.cream,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );
}
