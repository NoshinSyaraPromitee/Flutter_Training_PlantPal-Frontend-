import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/net_image.dart';
import '../../domain/model/plant.dart';
import 'health_badge.dart';

class PlantStatusCard extends StatelessWidget {
  const PlantStatusCard({
    super.key,
    required this.plant,
  });

  final Plant plant;

  Widget _row(
    IconData icon,
    Color color,
    String text,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.inter(
                  13,
                  c: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => AppCard(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        radius: 22,
        onTap: () => context.push('/plants/${plant.id}'),
        child: Row(
          children: [
            NetImage(
              plant.imageUrl,
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: AppTextStyles.inter(
                      19,
                      w: FontWeight.w700,
                      c: AppColors.greenPrimary,
                    ),
                  ),
                  Text(
                    plant.species,
                    style: AppTextStyles.inter(
                      13,
                      c: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  HealthBadge(health: plant.health),
                  _row(
                    Icons.water_drop,
                    AppColors.waterBlue,
                    plant.waterLevel,
                  ),
                  _row(
                    Icons.location_on,
                    AppColors.greenPrimary,
                    plant.location.isEmpty ? '—' : plant.location,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}