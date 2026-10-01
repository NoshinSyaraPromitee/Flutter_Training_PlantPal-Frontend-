import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color = Colors.white,
    this.radius = 20,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: color,
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: r,
        child: InkWell(borderRadius: r, onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Row(children: [
          Expanded(child: Text(text, style: AppTextStyles.inter(17, w: FontWeight.w700, c: AppColors.greenPrimary))),
          ?trailing,
        ]),
      );
}