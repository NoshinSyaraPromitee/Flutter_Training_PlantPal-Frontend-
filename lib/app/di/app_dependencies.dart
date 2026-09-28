import '../../core/network/api_client.dart';
import '../../core/network/failure.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/ai_doctor/data/datasources/ai_doctor_remote_data_source.dart';
import '../../features/ai_doctor/data/repositories/ai_doctor_repository_impl.dart';
import '../../features/ai_doctor/presentation/controllers/chat_controller.dart';
import '../../features/ai_doctor/presentation/controllers/scan_controller.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/care_guide/data/repositories/care_guide_local_repository.dart';
import '../../features/care_guide/domain/repositories/care_guide_repository.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/fertilizer/data/repositories/fertilizer_local_repository.dart';
import '../../features/fertilizer/presentation/controllers/fertilizer_controller.dart';
import '../../features/gamification/data/repositories/achievement_local_repository.dart';
import '../../features/gamification/domain/repositories/achievement_repository.dart';
import '../../features/payments/data/repositories/simulated_payment_repository.dart';
import '../../features/payments/presentation/controllers/payment_controller.dart';
import '../../features/plants/data/datasources/plant_remote_data_source.dart';
import '../../features/plants/data/repositories/plant_repository_impl.dart';
import '../../features/plants/domain/usecases/add_plant.dart';
import '../../features/plants/presentation/controllers/plants_controller.dart';
import '../../features/profile/presentation/controllers/settings_controller.dart';
import '../../features/reviews/data/repositories/review_local_repository.dart';
import '../../features/reviews/presentation/controllers/reviews_controller.dart';
import '../../features/shop/data/repositories/price_refresh_repository.dart';
import '../../features/shop/data/repositories/product_remote_repository.dart';
import '../../features/shop/presentation/controllers/shop_controller.dart';
import '../../features/wishlist/presentation/controllers/wishlist_controller.dart';

/// Composition root: the only place that knows which implementation backs which interface.
class AppDependencies {
  AppDependencies() {
    storage = const SecureStorage();
    settings = SettingsController(storage);
    Failure.currentLanguage = () => settings.language;
    api = ApiClient(storage, getLanguage: () => settings.language);

    auth = AuthController(
      AuthRepositoryImpl(AuthRemoteDataSource(api), storage),
    );
    api.onUnauthorized = auth.logout; // expired/invalid token -> back to login

    final plantRepo = PlantRepositoryImpl(PlantRemoteDataSource(api));
    plants = PlantsController(
      repository: plantRepo,
      addPlant: AddPlant(plantRepo),
    );

    final aiRepo = AiDoctorRepositoryImpl(AiDoctorRemoteDataSource(api));
    chat = ChatController(aiRepo);
    scan = ScanController(aiRepo);

    shop = ShopController(ProductRemoteRepository(api.dio, getLanguage: () => settings.language))..load();
    fertilizer = FertilizerController(FertilizerLocalRepository(getLanguage: () => settings.language))..load();
    settings.addListener(() {
      shop.load();
      fertilizer.load();
    });
    reviews = ReviewsController(ReviewLocalRepository());
    payment = PaymentController(SimulatedPaymentRepository());
    priceRefresh = PriceRefreshRepository(api.dio);
    careGuide = CareGuideLocalRepository(getLanguage: () => settings.language);
  }

  late final SecureStorage storage;
  late final ApiClient api;
  late final AuthController auth;
  late final PlantsController plants;
  late final ChatController chat;
  late final ScanController scan;
  late final ShopController shop;
  late final ReviewsController reviews;
  late final FertilizerController fertilizer;
  late final PaymentController payment;
  final CartController cart = CartController();
  final WishlistController wishlist = WishlistController();
  late final SettingsController settings;
  late final CareGuideRepository careGuide;
  final AchievementRepository achievements = AchievementLocalRepository();
  late final PriceRefreshRepository priceRefresh;
}
