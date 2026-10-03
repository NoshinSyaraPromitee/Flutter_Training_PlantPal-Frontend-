import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/plant_image.dart';

class PlantDetailsHeader extends StatelessWidget {
  const PlantDetailsHeader({
    super.key,
    required this.imageUrl,
    required this.onBack,
    required this.onMenuSelected,
    required this.editLabel,
    required this.deleteLabel,
  });

  final String imageUrl;
  final VoidCallback onBack;
  final ValueChanged<String> onMenuSelected;
  final String editLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlantImage(
          imageUrl,
          width: double.infinity,
          height: 300,
          radius: 0,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                  onPressed: onBack,
                ),
                PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.more_vert,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                  onSelected: onMenuSelected,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 20, color: AppColors.greenPrimary),
                          const SizedBox(width: 8),
                          Text(editLabel),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                          const SizedBox(width: 8),
                          Text(deleteLabel, style: const TextStyle(color: AppColors.danger)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
