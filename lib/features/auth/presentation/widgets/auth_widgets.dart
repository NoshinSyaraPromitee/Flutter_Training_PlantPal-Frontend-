import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, this.subtitle, required this.children});
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 24),
                child: Column(children: [
                  const SizedBox(
                    width: 130,
                    height: 130,
                    child: PlantMascotRive(),
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: AppTextStyles.screenTitle),
                  if (subtitle != null) Text(subtitle!, style: AppTextStyles.inter(15, c: AppColors.textMuted)),
                  const SizedBox(height: 28),
                  ...children,
                ]),
              ),
              Positioned(
                top: 4,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.greenPrimary),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/landing'),
                ),
              ),
            ]),
          ),
        ),
      );
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: auth.busy
              ? null
              : () async {
                  // On success, GoRouter's own refreshListenable (see
                  // app_router.dart) already redirects away from here once
                  // AuthController's status flips to authenticated - an
                  // explicit context.go('/home') here would fire a second,
                  // redundant navigation right after, which is what caused
                  // the brief "screen flashes back" glitch.
                  final ok = await auth.loginWithGoogle();
                  if (!context.mounted || ok) return;
                  if (auth.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
                  }
                },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('G', style: TextStyle(color: Color(0xFFDB4437), fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(width: 10),
            Text(auth.busy ? 'Signing in...' : 'Continue with Google', style: AppTextStyles.inter(16, w: FontWeight.w600)),
          ]),
        ),
      ),
      if (kDebugMode)
        TextButton(
          onPressed: () => auth.continueAsGuest(), // router redirects once status flips to guest
          child: const Text('Continue as guest (debug only)'),
        ),
    ]);
  }
}