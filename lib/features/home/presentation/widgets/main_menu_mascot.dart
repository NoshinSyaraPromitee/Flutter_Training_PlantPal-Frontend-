import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_speech_bubble.dart';

/// Mascot illustration + speech bubble shown at the top of the main menu.
class MainMenuMascot extends StatelessWidget {
  const MainMenuMascot({
    super.key,
    required this.mascotName,
    required this.onBubbleTap,
  });

  final String mascotName;
  final VoidCallback onBubbleTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final bubbleLeft = c.maxWidth / 2 + 52;
        final bubbleWidth = math.min(140.0, c.maxWidth - bubbleLeft);
        return SizedBox(
          height: 132,
          child: Stack(
            children: [
              Align(
                child: Container(
                  width: 84,
                  height: 108,
                  padding: const EdgeInsets.all(4),
                  color: const Color(0xFFCFE8B8),
                  child: const PlantMascotRive(),
                ),
              ),
              Positioned(
                left: bubbleLeft,
                top: 0,
                width: bubbleWidth,
                child: SpeechBubble(
                  text: '$mascotName is thirsty, give him some water',
                  onTap: onBubbleTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}