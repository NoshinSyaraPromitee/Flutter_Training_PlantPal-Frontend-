import 'package:flutter/material.dart';

import '../../../../core/widgets/plant_mascot_rive.dart';

/// Large decorative blob with the potted-plant mascot centered on top.
class LandingMascot extends StatelessWidget {
  const LandingMascot({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          Image.asset('assets/images/blob1.png', width: width, fit: BoxFit.contain),
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0.1, 0.35),
              child: SizedBox(
                width: width * (0.45 / 0.85),
                height: width * (0.45 / 0.85),
                child: const PlantMascotRive(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}