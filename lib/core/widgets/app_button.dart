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
    final bool isOutline = variant == AppButtonVariant.outline;

    final backgroundColor = switch (variant) {
      AppButtonVariant.orange => AppColors.buttonOrange,
      AppButtonVariant.green => AppColors.buttonGreen,
      AppButtonVariant.secondary => AppColors.greenCardFill,
      AppButtonVariant.outline => Colors.transparent,
    };

    final foregroundColor = switch (variant) {
      AppButtonVariant.orange => Colors.black87,
      AppButtonVariant.green => Colors.white,
      AppButtonVariant.secondary => AppColors.textDark,
      AppButtonVariant.outline => AppColors.greenPrimary,
    };

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isOutline
              ? BorderSide(color: AppColors.greenPrimary)
              : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 18),
                ],
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}