import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant {
  orange,
  green,
  secondary,
  outline,
}

/// Pill-shaped button matching the PlantPal design system.
/// Visible on both the gradient background and cream cards:
///  - green: deep teal fill, cream text, cream edge (stands out on teal)
///  - orange: warm tan fill, dark text
///  - secondary: soft light-green fill, dark text
///  - outline: cream fill, teal border and teal text
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.green,
    this.trailingIcon,
    this.leadingIcon,
    this.expand = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (variant) {
      AppButtonVariant.orange => AppColors.buttonOrange,
      AppButtonVariant.green => AppColors.buttonGreen,
      AppButtonVariant.secondary => AppColors.greenCardFill,
      AppButtonVariant.outline => AppColors.cream,
    };

    final foregroundColor = switch (variant) {
      AppButtonVariant.orange => const Color(0xFF1A1A1A),
      AppButtonVariant.green => AppColors.cream,
      AppButtonVariant.secondary => const Color(0xFF1A3A31),
      AppButtonVariant.outline => AppColors.greenPrimary,
    };

    final borderSide = switch (variant) {
      AppButtonVariant.green =>
        BorderSide(color: AppColors.cream.withValues(alpha: 0.85), width: 1.5),
      AppButtonVariant.outline =>
        const BorderSide(color: AppColors.greenPrimary, width: 2),
      _ => BorderSide.none,
    };

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.8),
        minimumSize: const Size(48, 50),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: borderSide,
        ),
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.30),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: foregroundColor,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 20),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 20),
                ],
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
