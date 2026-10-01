import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A -/value/+ stepper used for cart line-item quantities.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, VoidCallback onTap) => InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.greenPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.greenPrimary),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Icons.remove, onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('$value', style: AppTextStyles.inter(16, w: FontWeight.w700)),
        ),
        button(Icons.add, onPlus),
      ],
    );
  }
}