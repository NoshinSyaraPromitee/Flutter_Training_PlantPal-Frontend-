import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../l10n/app_localizations.dart';

/// Launch/loading screen shown while the app initializes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: GradientBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Stack(
              children: [
                Positioned(
                  left: w * 0.03,
                  top: h * 0.74,
                  width: w * 0.10,
                  child: Image.asset('assets/images/blob2.png'),
                ),
                Positioned(
                  left: w * 0.72,
                  top: h * 0.57,
                  width: w * 0.09,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset('assets/images/blob2.png'),
                  ),
                ),
                Positioned(
                  right: -w * 0.08,
                  bottom: -h * 0.03,
                  width: w * 0.36,
                  child: Opacity(
                    opacity: 0.55,
                    child: Image.asset('assets/images/blob2.png'),
                  ),
                ),
                Positioned(
                  left: w * 0.53,
                  top: h * 0.735,
                  width: w * 0.10,
                  child: Image.asset('assets/images/fern.png'),
                ),
                Positioned(
                  right: w * 0.05,
                  bottom: 0,
                  width: w * 0.20,
                  child: Image.asset('assets/images/fern.png'),
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.06),
                        Text(
                          'PlantPal',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heroTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.appTagline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5A4300),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: w * 0.85,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/blob1.png',
                                width: w * 0.85,
                                fit: BoxFit.contain,
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: const Alignment(0.1, 0.35),
                                  child: SizedBox(
                                    width: w * 0.45,
                                    child: Image.asset(
                                      'assets/images/splash_mascot.png',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: w * 0.42,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              minHeight: 3,
                              color: Color(0xFFDDB54A),
                              backgroundColor: Color(0xFFE9E4B4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.loadingLabel,
                          style: AppTextStyles.loadingCaption,
                        ),
                        SizedBox(height: h * 0.08),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}