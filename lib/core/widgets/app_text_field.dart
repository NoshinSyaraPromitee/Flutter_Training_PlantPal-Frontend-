import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantpal/core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.suffix,
    this.radius = 15,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fill = AppColors.isDark ? AppColors.surfaceGreen : AppColors.cream;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: AppColors.cream.withValues(alpha: AppColors.isDark ? 0.25 : 0.9),
        width: 1.5,
      ),
    );

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: obscure ? 1 : maxLines,
      onChanged: onChanged,
      cursorColor: AppColors.greenPrimary,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fill,
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: icon == null ? null : Icon(icon, color: AppColors.isDark ? Colors.white : AppColors.greenPrimary),
        suffixIcon: suffix,
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.greenPrimary, width: 2.5),
        ),
      ),
    );
  }
}
