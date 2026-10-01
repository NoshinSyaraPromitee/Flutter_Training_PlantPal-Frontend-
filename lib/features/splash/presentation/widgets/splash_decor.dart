import 'package:flutter/material.dart';

import '../../../../core/widgets/plant_mascot_rive.dart';

/// Decorative blobs and ferns scattered behind the splash screen content.
class SplashDecor extends StatelessWidget {
  const SplashDecor({super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = height;
    return Stack(children: [
      Positioned(left: w * 0.03, top: h * 0.74, width: w * 0.10, child: Image.asset('assets/images/blob2.png')),
      Positioned(
        left: w * 0.72,
        top: h * 0.57,
        width: w * 0.09,
        child: Opacity(opacity: 0.5, child: Image.asset('assets/images/blob2.png')),
      ),
      Positioned(
        right: -w * 0.08,
        bottom: -h * 0.03,
        width: w * 0.36,
        child: Opacity(opacity: 0.55, child: Image.asset('assets/images/blob2.png')),
      ),
      Positioned(left: w * 0.53, top: h * 0.735, width: w * 0.10, child: Image.asset('assets/images/fern.png')),
      Positioned(right: w * 0.05, bottom: 0, width: w * 0.20, child: Image.asset('assets/images/fern.png')),
    ]);
  }
}

/// Big blob illustration with the mascot layered on top, centered on the splash screen.
class SplashMascot extends StatelessWidget {
  const SplashMascot({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(children: [
        Image.asset('assets/images/blob1.png', width: width, fit: BoxFit.contain),
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0.1, 0.35),
            child: SizedBox(
              width: width * 0.55,
              height: width * 0.65,
              child: const PlantMascotRive(),
            ),
          ),
        ),
      ]),
    );
  }
}