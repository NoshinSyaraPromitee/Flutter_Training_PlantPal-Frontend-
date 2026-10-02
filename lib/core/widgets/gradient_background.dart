import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Landing-page background (gradient + floating blobs, sparkles, leaves)
/// shared by every screen.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.screenBackground),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              const Positioned.fill(
                child: IgnorePointer(child: BackgroundDecor()),
              ),
              child,
            ],
          ),
        ),
      );
}

/// Slowly drifting blobs, twinkling sparkles and leaves over the gradient.
class BackgroundDecor extends StatefulWidget {
  const BackgroundDecor({super.key});

  @override
  State<BackgroundDecor> createState() => _BackgroundDecorState();
}

class _BackgroundDecorState extends State<BackgroundDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cream = AppColors.cream;
    final k = AppColors.isDark ? 0.7 : 1.0;

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;

          return AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final t = _c.value * 2 * math.pi;

              Widget drift({
                double? left,
                double? right,
                double? top,
                double? bottom,
                required Widget child,
                double phase = 0,
                double amp = 12,
              }) {
                return Positioned(
                  left: left,
                  right: right,
                  top: top,
                  bottom: bottom,
                  child: Transform.translate(
                    offset: Offset(
                      math.sin(t + phase) * amp,
                      math.cos(t + phase * 1.3) * amp,
                    ),
                    child: child,
                  ),
                );
              }

              Widget blob(double size, Color color) => Container(
                    width: size,
                    height: size,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: color),
                  );

              Widget icon(IconData i, double size, double alpha,
                  {double rot = 0, double phase = 0}) {
                final twinkle = 0.65 + 0.35 * math.sin(t * 2 + phase);
                return Opacity(
                  opacity: twinkle,
                  child: Transform.rotate(
                    angle: rot + math.sin(t + phase) * 0.12,
                    child: Icon(i, size: size,
                        color: cream.withValues(alpha: alpha * k)),
                  ),
                );
              }

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Blobs
                  drift(
                    left: -60, top: -70, amp: 14,
                    child: blob(260, cream.withValues(alpha: 0.28 * k)),
                  ),
                  drift(
                    right: -70, bottom: -90, phase: 1.5, amp: 16,
                    child: blob(300, Colors.black.withValues(alpha: 0.14)),
                  ),
                  drift(
                    left: -50, bottom: h * 0.12, phase: 3, amp: 12,
                    child: blob(
                        190, AppColors.landingTop.withValues(alpha: 0.30 * k)),
                  ),
                  drift(
                    right: -55, top: h * 0.38, phase: 4.5, amp: 12,
                    child: blob(160, cream.withValues(alpha: 0.18 * k)),
                  ),

                  // Sparkles
                  drift(
                    right: 26, top: h * 0.12, phase: 0.5, amp: 6,
                    child: icon(Icons.auto_awesome, 24, 0.75, phase: 0.5),
                  ),
                  drift(
                    left: 24, top: h * 0.27, phase: 2, amp: 6,
                    child: icon(Icons.auto_awesome, 18, 0.6, phase: 2),
                  ),
                  drift(
                    left: w * 0.55, top: h * 0.06, phase: 3.5, amp: 5,
                    child: icon(Icons.auto_awesome, 14, 0.55, phase: 3.5),
                  ),
                  drift(
                    right: w * 0.28, bottom: h * 0.18, phase: 5, amp: 6,
                    child: icon(Icons.auto_awesome, 16, 0.6, phase: 5),
                  ),

                  // Leaves
                  drift(
                    right: 28, bottom: h * 0.26, phase: 1, amp: 10,
                    child: icon(Icons.spa_rounded, 34, 0.40, rot: 0.5, phase: 1),
                  ),
                  drift(
                    left: 16, top: h * 0.46, phase: 2.5, amp: 10,
                    child: icon(Icons.eco_rounded, 30, 0.38, rot: -0.6, phase: 2.5),
                  ),
                  drift(
                    right: 18, top: h * 0.60, phase: 4, amp: 10,
                    child: icon(Icons.eco_rounded, 26, 0.34, rot: 0.8, phase: 4),
                  ),
                  drift(
                    left: w * 0.38, bottom: 36, phase: 5.5, amp: 8,
                    child: icon(Icons.spa_rounded, 26, 0.34, rot: -0.3, phase: 5.5),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}