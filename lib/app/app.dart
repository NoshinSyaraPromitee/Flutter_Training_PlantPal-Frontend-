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
    _deps.auth.init();
    _deps.settings.load(); // restore saved theme (Provider)
    ref.read(localeControllerProvider.notifier).load(); // restore saved language (Riverpod)
  }

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
        ),
      ),
    );
  }
}