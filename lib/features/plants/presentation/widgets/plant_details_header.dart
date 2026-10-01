import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/net_image.dart';

class PlantDetailsHeader extends StatelessWidget {
  const PlantDetailsHeader({
    super.key,
    required this.imageUrl,
    required this.onBack,
    required this.onMenuSelected,
    required this.waterLabel,
    required this.fertilizeLabel,
    required this.deleteLabel,
  });

  final String imageUrl;
  final VoidCallback onBack;
  final ValueChanged<String> onMenuSelected;
  final String waterLabel;
  final String fertilizeLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NetImage(
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
                      value: 'water',
                      child: Text(waterLabel),
                    ),
                    PopupMenuItem(
                      value: 'fertilize',
                      child: Text(fertilizeLabel),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(deleteLabel),
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
