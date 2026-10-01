
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/Hello.gif',
                      width: 260,
                      height: 260,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'PlantPal',
                      style: AppTextStyles.heroTitle,
                    ),
                    Text(
                      l10n.appTagline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.inter(
                        14,
                        w: FontWeight.w700,
                        c: const Color(0xFF5A4300),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l10n.getStartedButton,
                    trailingIcon: Icons.arrow_circle_right_outlined,
                    onPressed: () => context.go('/login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

