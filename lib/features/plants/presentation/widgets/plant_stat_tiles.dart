import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlantStatTile extends StatelessWidget {
  const PlantStatTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.inter(
                13,
                w: FontWeight.w600,
                c: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.center,
              style: AppTextStyles.inter(
                15,
                w: FontWeight.w700,
                c: AppColors.greenPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantTaskRow extends StatelessWidget {
  const PlantTaskRow({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                15,
                w: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}