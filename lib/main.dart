import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'app/app.dart';
import 'app/di/app_dependencies.dart';
import 'app/riverpod_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  final deps = AppDependencies();

  runApp(
    ProviderScope(
      // Riverpod reads the very same instances that Provider uses.
      overrides: [
        secureStorageProvider.overrideWithValue(deps.storage),
        apiClientProvider.overrideWithValue(deps.api),
        authControllerProvider.overrideWith((ref) => deps.auth),
        plantsControllerProvider.overrideWith((ref) => deps.plants),
        chatControllerProvider.overrideWith((ref) => deps.chat),
        scanControllerProvider.overrideWith((ref) => deps.scan),
        shopControllerProvider.overrideWith((ref) => deps.shop),
        cartControllerProvider.overrideWith((ref) => deps.cart),
        wishlistControllerProvider.overrideWith((ref) => deps.wishlist),
        reviewsControllerProvider.overrideWith((ref) => deps.reviews),
        fertilizerControllerProvider.overrideWith((ref) => deps.fertilizer),
        paymentControllerProvider.overrideWith((ref) => deps.payment),
        settingsControllerProvider.overrideWith((ref) => deps.settings),
        careGuideRepositoryProvider.overrideWithValue(deps.careGuide),
        achievementRepositoryProvider.overrideWithValue(deps.achievements),
        priceRefreshRepositoryProvider.overrideWithValue(deps.priceRefresh),
      ],
      child: PlantPalApp(deps: deps),
    ),
  );
}