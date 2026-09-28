import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'di/app_dependencies.dart';
import 'riverpod_providers.dart';
import 'router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../l10n/app_localizations.dart';

class PlantPalApp extends StatefulWidget {
  const PlantPalApp({super.key});
  @override
  State<PlantPalApp> createState() => _PlantPalAppState();
}

class _PlantPalAppState extends State<PlantPalApp> {
  final AppDependencies _deps = AppDependencies();
  late final GoRouter _router = AppRouter.create(_deps.auth);

  @override
  void initState() {
    super.initState();
    _deps.auth.addListener(_onAuthChanged);
    _deps.auth.init(); // restore saved session
    _deps.settings.init(); // restore saved settings/language
  }

  /// Drop per-user state when the session ends.
  void _onAuthChanged() {
    if (_deps.auth.status == AuthStatus.unauthenticated) {
      _deps.plants.clear();
      _deps.cart.clear();
      _deps.wishlist.clear();
    }
  }

  @override
  void dispose() {
    _deps.auth.removeListener(_onAuthChanged);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        secureStorageProvider.overrideWith((ref) => _deps.storage),
        apiClientProvider.overrideWith((ref) => _deps.api),
        authControllerProvider.overrideWith((ref) => _deps.auth),
        plantsControllerProvider.overrideWith((ref) => _deps.plants),
        chatControllerProvider.overrideWith((ref) => _deps.chat),
        scanControllerProvider.overrideWith((ref) => _deps.scan),
        shopControllerProvider.overrideWith((ref) => _deps.shop),
        cartControllerProvider.overrideWith((ref) => _deps.cart),
        wishlistControllerProvider.overrideWith((ref) => _deps.wishlist),
        reviewsControllerProvider.overrideWith((ref) => _deps.reviews),
        fertilizerControllerProvider.overrideWith((ref) => _deps.fertilizer),
        paymentControllerProvider.overrideWith((ref) => _deps.payment),
        settingsControllerProvider.overrideWith((ref) => _deps.settings),
        careGuideRepositoryProvider.overrideWith((ref) => _deps.careGuide),
        achievementRepositoryProvider.overrideWith((ref) => _deps.achievements),
        priceRefreshRepositoryProvider.overrideWith((ref) => _deps.priceRefresh),
      ],
      child: _LocalizedApp(router: _router),
    );
  }
}

class _LocalizedApp extends ConsumerWidget {
  const _LocalizedApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp.router(
      title: 'PlantPal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: Locale(settings.language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
