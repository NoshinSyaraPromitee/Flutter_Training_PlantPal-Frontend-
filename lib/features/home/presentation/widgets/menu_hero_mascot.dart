import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';

/// Rive mascot in a framed box with its name tag underneath.
class MenuHeroMascot extends StatelessWidget {
  const MenuHeroMascot({super.key});

  static const String _mascotName = 'Tetoro';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 108,
            height: 124,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD4C26E),
                  Color(0xFF7F9B5B),
                  Color(0xFF1B5A4B),
                ],
              ),
              border: Border.all(color: MenuColors.cream, width: 2.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: const PlantMascotRive(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: MenuColors.cream,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _mascotName,
              style: AppTextStyles.inter(
                12,
                w: FontWeight.w800,
                c: MenuColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
