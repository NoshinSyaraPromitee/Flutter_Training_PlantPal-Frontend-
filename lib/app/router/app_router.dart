import 'package:go_router/go_router.dart';
import '../shell/main_shell.dart';
import '../../features/ai_doctor/presentation/screens/ai_chat_screen.dart';
import '../../features/ai_doctor/presentation/screens/scan_plant_screen.dart';
import '../../features/ai_doctor/presentation/screens/scan_result_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/care_guide/presentation/screens/care_guide_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/order_success_screen.dart';
import '../../features/fertilizer/presentation/screens/fertilizer_details_screen.dart';
import '../../features/fertilizer/presentation/screens/fertilizer_screen.dart';
import '../../features/home/presentation/screens/main_menu_screen.dart';
import '../../features/payments/presentation/screens/payment_screen.dart';
import '../../features/plants/presentation/screens/add_plant_screen.dart';
import '../../features/plants/presentation/screens/care_calendar_screen.dart';
import '../../features/plants/presentation/screens/my_plants_screen.dart';
import '../../features/plants/presentation/screens/plant_details_screen.dart';
import '../../features/plants/presentation/screens/plant_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/shop/presentation/screens/product_details_screen.dart';
import '../../features/shop/presentation/screens/shop_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';

class AppRouter {
  AppRouter._();

  static const _public = {'/', '/landing', '/login', '/register'};
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

      // Bottom-tab shell
      StatefulShellRoute.indexedStack(
        builder: (c, s, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (c, s) => const MainMenuScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scan',
                builder: (c, s) => const ScanPlantScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/shop', builder: (c, s) => const ShopScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai-doctor',
                builder: (c, s) => const AiChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (c, s) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes (pushed over the tabs)
      GoRoute(
        path: '/scan-result',
        builder: (c, s) => const ScanResultScreen(),
      ),
      GoRoute(
        path: '/plants',
        builder: (c, s) => const MyPlantsScreen(),
        routes: [
          GoRoute(path: 'add', builder: (c, s) => const AddPlantScreen()),
          GoRoute(
            path: ':id',
            builder: (c, s) =>
                PlantDetailsScreen(plantId: s.pathParameters['id']!),
            routes: [
              // Scan launched from a plant, so the saved diagnosis is linked to it.
              GoRoute(
                path: 'scan',
                builder: (c, s) =>
                    ScanPlantScreen(plantId: s.pathParameters['id']),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/care-calendar',
        builder: (c, s) => const CareCalendarScreen(),
      ),
      GoRoute(
        path: '/plant-history',
        builder: (c, s) => const PlantHistoryScreen(),
      ),
      GoRoute(
        path: '/care-guide',
        builder: (c, s) =>
            CareGuideScreen(plantId: s.uri.queryParameters['plantId']),
      ),
      GoRoute(
        path: '/fertilizer',
        builder: (c, s) => const FertilizerScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (c, s) =>
                FertilizerDetailsScreen(id: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/shop/product/:id',
        builder: (c, s) =>
            ProductDetailsScreen(productId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/wishlist', builder: (c, s) => const WishlistScreen()),
      GoRoute(path: '/cart', builder: (c, s) => const CartScreen()),
      GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
      GoRoute(
        path: '/payment',
        builder: (c, s) => PaymentScreen(
          total: double.tryParse(s.uri.queryParameters['total'] ?? '') ?? 0,
          eta: s.uri.queryParameters['eta'] ?? '3-5 Days',
        ),
      ),
      GoRoute(
        path: '/order-success',
        builder: (c, s) => OrderSuccessScreen(
          orderId: s.uri.queryParameters['orderId'] ?? '',
          eta: s.uri.queryParameters['eta'] ?? '3-5 Days',
        ),
      ),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    ],
  );
}
