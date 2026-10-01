import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
    this.radius = 20,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;

  /// Defaults to the landing cream (or the dark surface in dark mode).
  final Color? color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    final fill = color ?? (AppColors.isDark ? AppColors.surfaceGreen : AppColors.cream);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: fill,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.28),
        shape: RoundedRectangleBorder(
          borderRadius: r,
          side: BorderSide(
            color: AppColors.cream.withValues(alpha: AppColors.isDark ? 0.10 : 0.75),
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Section label that sits on the gradient background, so it uses the
/// cream heading colour rather than the card text colour.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Row(children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                17,
                w: FontWeight.w700,
                c: AppColors.brownHeading,
              ),
            ),
          ),
          ?trailing,
        ]),
      );
}
