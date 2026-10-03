import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/model/plant.dart';

/// Colour for a health state (same palette as the health badge).
Color healthColor(HealthState s) => switch (s) {
      HealthState.critical => const Color(0xFFE53935),
      HealthState.needsCare => const Color(0xFFFB8C00),
      HealthState.okay => const Color(0xFF7CB342),
      HealthState.thriving => const Color(0xFF43A047),
    };

/// A ring that fills to [health]% around [child] (photo or score).
class HealthRing extends StatelessWidget {
  const HealthRing({
    super.key,
    required this.health,
    required this.state,
    required this.child,
    this.size = 84,
    this.stroke = 5,
  });

  final int health;
  final HealthState state;
  final Widget child;
  final double size;
  final double stroke;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          fraction: (health / 100).clamp(0.0, 1.0),
          color: healthColor(state),
          stroke: stroke,
        ),
        child: Padding(
          padding: EdgeInsets.all(stroke + 3),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.color,
    required this.stroke,
  });

  final double fraction;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color.withValues(alpha: 0.18);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * fraction, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter o) =>
      o.fraction != fraction || o.color != color || o.stroke != stroke;
}
