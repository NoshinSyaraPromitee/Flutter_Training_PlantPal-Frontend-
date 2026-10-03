import 'package:plantpal/core/network/api_client.dart';
import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/core/storage/secure_storage.dart';
import 'package:plantpal/features/ai_doctor/data/datasources/ai_doctor_remote_data_source.dart';
import 'package:plantpal/features/ai_doctor/data/repositories/ai_doctor_repository_impl.dart';
import 'package:plantpal/features/ai_doctor/presentation/providers/chat_provider.dart';
import 'package:plantpal/features/ai_doctor/presentation/providers/scan_provider.dart';
import 'package:plantpal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:plantpal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/care_guide/data/repositories/care_guide_local_repository.dart';
import 'package:plantpal/features/care_guide/domain/repositories/care_guide_repository.dart';
import 'package:plantpal/features/cart/presentation/providers/cart_provider.dart';
import 'package:plantpal/features/fertilizer/data/repositories/fertilizer_remote_repository.dart';
import 'package:plantpal/features/fertilizer/presentation/providers/fertilizer_provider.dart';
import 'package:plantpal/features/gamification/data/repositories/achievement_local_repository.dart';
import 'package:plantpal/features/gamification/domain/repositories/achievement_repository.dart';
import 'package:plantpal/features/gamification/presentation/providers/points_provider.dart';
import 'package:plantpal/features/payments/data/repositories/remote_payment_repository.dart';
import 'package:plantpal/features/payments/presentation/providers/payment_provider.dart';
import 'package:plantpal/features/plants/data/datasources/plant_remote_data_source.dart';
import 'package:plantpal/features/plants/data/repositories/plant_repository_impl.dart';
import 'package:plantpal/features/plants/domain/usecases/add_plant.dart';
import 'package:plantpal/features/plants/presentation/providers/plants_provider.dart';
import 'package:plantpal/features/profile/presentation/providers/settings_provider.dart';
import 'package:plantpal/features/reviews/data/repositories/review_local_repository.dart';
import 'package:plantpal/features/reviews/presentation/providers/reviews_provider.dart';
import 'package:plantpal/features/shop/data/repositories/price_refresh_repository.dart';
import 'package:plantpal/features/shop/data/repositories/product_remote_repository.dart';
import 'package:plantpal/features/shop/presentation/providers/shop_provider.dart';
import 'package:plantpal/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Composition root: the only place that knows which implementation backs which interface.
/// The same instances

/// The same instances are exposed to Provider (see [providers]) and to Riverpod
/// (see the overrides in main.dart), so both worlds share one state.
class AppDependencies {
  AppDependencies() {
    api = ApiClient(storage);

    auth = AuthController(
      AuthRepositoryImpl(AuthRemoteDataSource(api), storage),
    );
    api.onUnauthorized = auth.logout; // expired/invalid token -> back to login

    final plantRepo = PlantRepositoryImpl(PlantRemoteDataSource(api));
    final aiRepo = AiDoctorRepositoryImpl(AiDoctorRemoteDataSource(api));

    plants = PlantsController(
      repository: plantRepo,
      addPlant: AddPlant(plantRepo),
    );
    chat = ChatController(aiRepo, storage);
    // Restore the saved conversation once signed in; forget it on logout.
    AuthStatus? lastAuthStatus;
    auth.addListener(() {
      final status = auth.status;
      if (status == lastAuthStatus) return;
      lastAuthStatus = status;
      if (status == AuthStatus.authenticated) {
        chat.loadHistory();
      } else if (status == AuthStatus.unauthenticated) {
        chat.reset();
        api.clearImageCache();
      }
    });
    scan = ScanController(aiRepo);

    api.getLanguage = () => settings.language;
    shop = ShopController(
      ProductRemoteRepository(api.dio, getLanguage: () => settings.language),
    );
    reviews = ReviewsController(ReviewLocalRepository());
    payment = PaymentController(RemotePaymentRepository(api.dio));
    fertilizer = FertilizerController(
      FertilizerRemoteRepository(api.dio, getLanguage: () => settings.language),
    );
    settings = SettingsController(storage);
    careGuide = CareGuideLocalRepository(getLanguage: () => settings.language);
    priceRefresh = PriceRefreshRepository(api.dio);

    Failure.currentLanguage = () => settings.language;

    points = PointsController(storage)..load();
    plants.onCareLogged = points.add;
  }

  final SecureStorage storage = const SecureStorage();
  late final ApiClient api;

  late final AuthController auth;
  late final PlantsController plants;
  late final ChatController chat;
  late final ScanController scan;
  late final ShopController shop;
  late final ReviewsController reviews;
  late final PaymentController payment;
  late final FertilizerController fertilizer;
  late final SettingsController settings;
  late final CareGuideRepository careGuide;
  late final PriceRefreshRepository priceRefresh;
  final CartController cart = CartController();
  final WishlistController wishlist = WishlistController();
  final AchievementRepository achievements = AchievementLocalRepository();
  late final PointsController points;

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<AuthController>.value(value: auth),
        ChangeNotifierProvider<PlantsController>.value(value: plants),
        ChangeNotifierProvider<ChatController>.value(value: chat),
        ChangeNotifierProvider<ScanController>.value(value: scan),
        ChangeNotifierProvider<ShopController>.value(value: shop),
        ChangeNotifierProvider<CartController>.value(value: cart),
        ChangeNotifierProvider<WishlistController>.value(value: wishlist),
        ChangeNotifierProvider<ReviewsController>.value(value: reviews),
        ChangeNotifierProvider<PaymentController>.value(value: payment),
        ChangeNotifierProvider<SettingsController>.value(value: settings),
        ChangeNotifierProvider<PointsController>.value(value: points),
        Provider<CareGuideRepository>.value(value: careGuide),
        Provider<AchievementRepository>.value(value: achievements),
      ];
}