import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';

/// Pops the current route if there's something to pop back to, otherwise
/// falls back to [fallback] - so it's never a dead end.
/// Drawn as a cream circle with a teal arrow so it is visible on any part
/// of the gradient.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.fallback = '/home',
    this.color,
    this.circleBackground = true,
  });

  final String fallback;
  final Color? color;
  final bool circleBackground;

  @override
  Widget build(BuildContext context) {
    final arrowColor = color ?? AppColors.greenPrimary;
    final button = IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Icon(Icons.arrow_back_rounded, color: arrowColor, size: 24),
      onPressed: () => context.canPop() ? context.pop() : context.go(fallback),
    );

    if (!circleBackground) return button;

    return Center(
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cream,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.greenPrimary, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FittedBox(child: button),
      ),
    );
  }
}
