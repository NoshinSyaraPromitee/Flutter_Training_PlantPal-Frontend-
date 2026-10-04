import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'maintenance_colors.dart';

/// Fixed "Add another plant" / "Back" row shown under the Maintenance screen.
class MaintenanceBottomBar extends StatelessWidget {
  const MaintenanceBottomBar({super.key, required this.onAddPlant, required this.onBack});

  final VoidCallback onAddPlant;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _action(icon: Icons.add, label: 'Add another plant', onTap: onAddPlant, filled: true),
            _action(icon: Icons.arrow_back, label: 'Back', onTap: onBack, filled: false),
          ],
        ),
      ),
    );
  }

  Widget _action({required IconData icon, required String label, required VoidCallback onTap, required bool filled}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: filled ? IconButton.styleFrom(backgroundColor: Colors.white, shape: const CircleBorder()) : null,
          icon: Icon(icon, color: filled ? AppColors.greenPrimary : kMaintenanceIconLight),
          onPressed: onTap,
        ),
        Text(label, style: AppTextStyles.inter(11, w: FontWeight.w600, c: kMaintenanceIconLight)),
      ],
    );
  }
}