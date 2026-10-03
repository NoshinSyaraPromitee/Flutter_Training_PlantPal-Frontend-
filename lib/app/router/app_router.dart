import 'package:go_router/go_router.dart';
import 'package:plantpal/app/router/plant_routes.dart';
import 'package:plantpal/app/router/shop_routes.dart';
import 'package:plantpal/app/shell/main_shell.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/ai_chat_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/scan_plant_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/scan_result_screen.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:plantpal/features/auth/presentation/screens/landing_screen.dart';
import 'package:plantpal/features/auth/presentation/screens/login_screen.dart';
import 'package:plantpal/features/auth/presentation/screens/register_screen.dart';
import 'package:plantpal/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:plantpal/features/home/presentation/screens/main_menu_screen.dart';
import 'package:plantpal/features/profile/presentation/screens/profile_screen.dart';
import 'package:plantpal/features/profile/presentation/screens/settings_screen.dart';
import 'package:plantpal/features/shop/presentation/screens/shop_screen.dart';
import 'package:plantpal/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const _public = {'/', '/landing', '/login', '/register', '/forgot-password', '/reset-password'};
  static const _loggedOutOnly = {'/landing', '/login', '/register'};

  static GoRouter create(AuthController auth) => GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    // Route guard: everything except splash/landing/login/register needs a session.
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (auth.status == AuthStatus.unknown) return loc == '/' ? null : '/';
      if (!auth.isAllowedIn && !_public.contains(loc)) return '/landing';
      if (auth.isAllowedIn && _loggedOutOnly.contains(loc)) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/landing', builder: (c, s) => const LandingScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (c, s) => ForgotPasswordScreen(email: s.extra as String?)),
      GoRoute(path: '/reset-password', builder: (c, s) => ResetPasswordScreen(email: s.extra as String?)),

      // Bottom-tab shell
      StatefulShellRoute.indexedStack(
        builder: (c, s, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (c, s) => const MainMenuScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/scan', builder: (c, s) => const ScanPlantScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/shop', builder: (c, s) => const ShopScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/ai-doctor', builder: (c, s) => const AiChatScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen())],
          ),
        ],
      ),

      // Full-screen routes (pushed over the tabs)
      GoRoute(path: '/scan-result', builder: (c, s) => const ScanResultScreen()),
      ...plantRoutes,
      ...shopRoutes,
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    ],
  );
}