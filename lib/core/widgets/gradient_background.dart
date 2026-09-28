import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Wraps a screen body with the orange-to-green gradient background used
/// throughout the PlantPal Figma design.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.screenBackground),
        child: child,
      ),
    );
  }
}
