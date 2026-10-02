import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/l10n/app_localizations.dart';

// Palette sampled from the Rive artboard (golden top -> deep teal bottom).
const _riveTop = Color(0xFFD4C26E);
const _riveMid = Color(0xFF7F9B5B);
const _riveBottom = Color(0xFF1B5A4B);
const _cream = Color(0xFFFFF6DC);

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _riveBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
            colors: [_riveTop, _riveMid, _riveBottom],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: IgnorePointer(child: _Decor())),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final cardSize = math
                      .min(c.maxWidth * 0.72, c.maxHeight * 0.40)
                      .clamp(200.0, 320.0);

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 24,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _float,
                                  builder: (context, child) {
                                    final t = Curves.easeInOut
                                        .transform(_float.value);
                                    return Transform.translate(
                                      offset: Offset(0, -10 * t),
                                      child: child,
                                    );
                                  },
                                  child: _MascotCard(size: cardSize),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'PlantPal',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.heroTitle.copyWith(
                                    color: _cream,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.appTagline,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.inter(
                                    15,
                                    w: FontWeight.w700,
                                    c: _cream.withValues(alpha: 0.92),
                                  ),
                                ),
                                const SizedBox(height: 44),
                                _GetStartedButton(
                                  label: l10n.getStartedButton,
                                  onPressed: () => context.go('/login'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _cream,
          foregroundColor: _riveBottom,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.inter(15, w: FontWeight.w700, c: _riveBottom),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_circle_right_outlined, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Rive mascot inside a rounded card that reuses the artboard's own gradient,
/// so it sits naturally on the matching page background.
class _MascotCard extends StatelessWidget {
  const _MascotCard({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.16;
    return SizedBox(
      width: size * 1.25,
      height: size * 1.25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft cream glow behind the card
          Container(
            width: size * 1.2,
            height: size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _cream.withValues(alpha: 0.35),
                  _cream.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_riveTop, _riveMid, _riveBottom],
              ),
              border: Border.all(
                color: _cream.withValues(alpha: 0.75),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - 3),
              child: const PlantMascotRive(),
            ),
          ),
          Positioned(
            top: size * 0.04,
            right: size * 0.02,
            child: Transform.rotate(
              angle: 0.6,
              child: const Icon(Icons.eco_rounded, size: 34, color: _cream),
            ),
          ),
          Positioned(
            bottom: size * 0.06,
            left: size * 0.0,
            child: Transform.rotate(
              angle: -0.7,
              child: Icon(
                Icons.eco_rounded,
                size: 26,
                color: _cream.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft light blobs, sparkles and leaves over the gradient.
class _Decor extends StatelessWidget {
  const _Decor();

  @override
  Widget build(BuildContext context) {
    Widget blob(double size, Color color) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );

    return Stack(
      children: [
        Positioned(
          top: -70,
          left: -60,
          child: blob(240, _cream.withValues(alpha: 0.18)),
        ),
        Positioned(
          bottom: -90,
          right: -70,
          child: blob(280, Colors.black.withValues(alpha: 0.10)),
        ),
        Positioned(
          bottom: 60,
          left: -40,
          child: blob(160, _riveTop.withValues(alpha: 0.12)),
        ),
        Positioned(
          top: 110,
          right: 26,
          child: Icon(Icons.auto_awesome,
              size: 22, color: _cream.withValues(alpha: 0.55)),
        ),
        Positioned(
          top: 220,
          left: 24,
          child: Icon(Icons.auto_awesome,
              size: 16, color: _cream.withValues(alpha: 0.4)),
        ),
        Positioned(
          bottom: 200,
          right: 30,
          child: Transform.rotate(
            angle: 0.5,
            child: Icon(Icons.spa_rounded,
                size: 28, color: _cream.withValues(alpha: 0.25)),
          ),
        ),
      ],
    );
  }
}
