import 'package:go_router/go_router.dart';
import 'package:plantpal/app/router/plant_routes.dart';
import 'package:plantpal/app/router/shop_routes.dart';
import 'package:plantpal/app/shell/main_shell.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/ai_chat_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/scan_plant_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/scan_result_screen.dart';
import 'package:plantpal/features/home/presentation/screens/main_menu_screen.dart';
import 'package:plantpal/features/profile/presentation/screens/profile_screen.dart';
import 'package:plantpal/features/profile/presentation/screens/settings_screen.dart';
import 'package:plantpal/features/shop/presentation/screens/shop_screen.dart';
import 'package:plantpal/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  // AUTH DISABLED (temporary): no route guard and no landing/login/register
  // routes. Splash goes straight to /home. To re-enable, restore the guard
  // (redirect + refreshListenable on AuthController) and the auth routes
  // from git history.
  static GoRouter create() => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashScreen()),

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