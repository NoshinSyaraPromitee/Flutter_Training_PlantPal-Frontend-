import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:go_router/go_router.dart';
import 'package:plantpal/app/di/app_dependencies.dart';
import 'package:plantpal/app/router/app_router.dart';
import 'package:plantpal/core/locale/locale_controller.dart';
import 'package:plantpal/core/theme/app_theme.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/profile/presentation/providers/settings_provider.dart';
import 'package:plantpal/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PlantPalApp extends ConsumerStatefulWidget {
  const PlantPalApp({super.key, required this.deps});
  final AppDependencies deps;
  @override
  ConsumerState<PlantPalApp> createState() => _PlantPalAppState();
}

class _PlantPalAppState extends ConsumerState<PlantPalApp> {
  late final AppDependencies _deps = widget.deps;
  late final GoRouter _router = AppRouter.create(_deps.auth);

  @override
  void initState() {
    super.initState();
    _deps.auth.addListener(_onAuthChanged);
    _deps.settings.addListener(_onSettingsChanged);
    _deps.auth.init();
    _deps.settings.load(); // restore saved theme (Provider)
    ref.read(localeControllerProvider.notifier).load(); // restore saved language (Riverpod)
  }

  bool _shopLoaded = false;
  String? _shopLang;

  void _onAuthChanged() {
    final status = _deps.auth.status;
    if (status == AuthStatus.authenticated && !_shopLoaded) {
      _shopLoaded = true;
      _shopLang = _deps.settings.language;
      _deps.shop.load();
      _deps.fertilizer.load();
    }
    if (status == AuthStatus.unauthenticated) {
      _shopLoaded = false;
      _deps.plants.clear();
      _deps.cart.clear();
      _deps.wishlist.clear();
      _deps.shop.clear();
      _deps.fertilizer.clear();
    }
  }

  // Category names and product text come back in the UI language.
  void _onSettingsChanged() {
    if (_shopLoaded && _deps.settings.language != _shopLang) {
      _shopLang = _deps.settings.language;
      _deps.shop.load();
      _deps.fertilizer.load();
    }
  }

  @override
  void dispose() {
    _deps.auth.removeListener(_onAuthChanged);
    _deps.settings.removeListener(_onSettingsChanged);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);

    return MultiProvider(
      providers: _deps.providers,
      child: Consumer<SettingsController>(
        builder: (context, settings, _) => MaterialApp.router(
          key: ValueKey('${settings.darkMode}_${locale.languageCode}'), // full rebuild on theme/language toggle
          title: 'PlantPal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: _router,
          // Guard against overflow when the system font size is very large.
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}