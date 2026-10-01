import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heroTitle => GoogleFonts.fredoka(
        fontSize: 60,
        fontWeight: FontWeight.w600,
        color: AppColors.brownHeading,
        letterSpacing: 0.2,
      );

  static TextStyle get screenTitle => GoogleFonts.fredoka(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.brownHeading,
        letterSpacing: 0.2,
      );

  static TextStyle get displayMedium => GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.brownHeading,
      );

  static TextStyle get titleLarge => GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get sectionLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.greenPrimary,
        letterSpacing: 0.8,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textMuted,
      );

  static TextStyle get loadingCaption => GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.orangeAccent,
      );

  static TextStyle get chatLabel => GoogleFonts.inter(
        fontSize: 11,
        color: AppColors.greenPrimary,
      );

  static TextStyle get bodyText => GoogleFonts.inter(
        fontSize: 13,
        height: 1.5,
        color: AppColors.textDark,
      );

  static TextStyle inter(
    double size, {
    FontWeight w = FontWeight.w500,
    Color? c,
    double? h,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: w,
        color: c ?? AppColors.textDark,
        height: h,
      );
}