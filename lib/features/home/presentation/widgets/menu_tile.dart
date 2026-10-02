import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';

enum MenuTileLayout { tall, compact, wide }

/// Bento tile used on the home menu.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.layout,
    required this.label,
    required this.image,
    required this.onTap,
    this.fill = MenuColors.cream,
    this.dark = false,
  });

  final MenuTileLayout layout;
  final String label;
  final String image;
  final VoidCallback onTap;
  final Color fill;

  /// Dark (teal) tile: cream text, image sits in a cream frame.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? MenuColors.cream : MenuColors.ink;

    final Widget content = switch (layout) {
      MenuTileLayout.tall => Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: _ArrowDot(dark: dark),
              ),
              Expanded(child: Image.asset(image, fit: BoxFit.contain)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.inter(16, w: FontWeight.w800, c: ink),
              ),
            ],
          ),
        ),
      MenuTileLayout.compact => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: Image.asset(image, fit: BoxFit.contain)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTextStyles.inter(14, w: FontWeight.w800, c: ink),
                ),
              ),
            ],
          ),
        ),
      MenuTileLayout.wide => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: dark
                      ? MenuColors.cream
                      : Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  style: AppTextStyles.inter(17, w: FontWeight.w800, c: ink),
                ),
              ),
              const SizedBox(width: 8),
              _ArrowDot(dark: dark),
            ],
          ),
        ),
    };

    return Material(
      color: fill,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: dark
              ? MenuColors.cream.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.7),
          width: 2,
        ),
      ),
      child: InkWell(onTap: onTap, child: content),
    );
  }
}

class _ArrowDot extends StatelessWidget {
  const _ArrowDot({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dark ? MenuColors.cream : MenuColors.teal,
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 18,
        color: dark ? MenuColors.teal : MenuColors.cream,
      ),
    );
  }
}
