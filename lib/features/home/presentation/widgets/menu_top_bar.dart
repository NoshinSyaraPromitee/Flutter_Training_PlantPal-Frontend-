import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';

class MenuPointsChip extends StatelessWidget {
  const MenuPointsChip({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 14, 5),
      decoration: BoxDecoration(
        color: MenuColors.cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: MenuColors.teal, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE04A), Color(0xFFF5A300)],
              ),
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 16,
              color: Color(0xFFFFF2A8),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.inter(
              12,
              w: FontWeight.w800,
              c: MenuColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuBellButton extends StatelessWidget {
  const MenuBellButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MenuColors.cream,
      elevation: 3,
      shape: const CircleBorder(
        side: BorderSide(color: MenuColors.teal, width: 1.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(9),
          child: Icon(
            Icons.notifications_none_rounded,
            color: MenuColors.teal,
            size: 24,
          ),
        ),
      ),
    );
  }
}
