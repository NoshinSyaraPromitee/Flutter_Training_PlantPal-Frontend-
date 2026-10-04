import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MyPlantPal'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Turn your thumb green.'**
  String get splashTagline;

  /// No description provided for @homeHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make your\njungle thrive'**
  String get homeHeaderTitle;

  /// No description provided for @homeHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnose issues, mix custom plant food, and grow with confidence.'**
  String get homeHeaderSubtitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning! Ready to check on your leaf babies?'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon! How are your green companions holding up?'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening! Time for a quick sundown check-in.'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Still up? Rest easy—your plants are sleeping too.'**
  String get greetingNight;

  /// No description provided for @greetingPlantThirsty.
  ///
  /// In en, this message translates to:
  /// **'Someone\'s looking a bit parched today!'**
  String get greetingPlantThirsty;

  /// No description provided for @greetingWeatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy skies ahead—hold off on watering outdoor plants.'**
  String get greetingWeatherRain;

  /// No description provided for @greetingWeatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Storm\'s rolling in! Move vulnerable plants inside.'**
  String get greetingWeatherThunderstorm;

  /// No description provided for @greetingWeatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Frost alert! Bring tender plants into the warm.'**
  String get greetingWeatherSnow;

  /// No description provided for @greetingWeatherFog.
  ///
  /// In en, this message translates to:
  /// **'Misty morning—your tropical plants will love the humidity!'**
  String get greetingWeatherFog;

  /// No description provided for @greetingWeatherHot.
  ///
  /// In en, this message translates to:
  /// **'Sizzling {temperature}°C today! Keep an eye out for dry soil.'**
  String greetingWeatherHot(int temperature);

  /// No description provided for @uploadPlantPhoto.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo of your plant'**
  String get uploadPlantPhoto;

  /// No description provided for @quickActionsLabel.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get quickActionsLabel;

  /// No description provided for @myPlantsLabel.
  ///
  /// In en, this message translates to:
  /// **'My Plants'**
  String get myPlantsLabel;

  /// No description provided for @maintainance.
  ///
  /// In en, this message translates to:
  /// **'Plant Care'**
  String get maintainance;

  /// No description provided for @diseaseDetectionTile.
  ///
  /// In en, this message translates to:
  /// **'AI Plant Doctor'**
  String get diseaseDetectionTile;

  /// No description provided for @fertilizerRecipesLabel.
  ///
  /// In en, this message translates to:
  /// **'DIY Plant Food'**
  String get fertilizerRecipesLabel;

  /// No description provided for @shopLabel.
  ///
  /// In en, this message translates to:
  /// **'Garden Shop'**
  String get shopLabel;

  /// No description provided for @chatWithExpertLabel.
  ///
  /// In en, this message translates to:
  /// **'Ask an Expert'**
  String get chatWithExpertLabel;

  /// No description provided for @mainMenuButton.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenuButton;

  /// No description provided for @fertilizerHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'DIY Plant Food Lab'**
  String get fertilizerHeaderTitle;

  /// No description provided for @fertilizerHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrient-rich homemade recipes tailored for every growth stage.'**
  String get fertilizerHeaderSubtitle;

  /// No description provided for @addFertilizerButton.
  ///
  /// In en, this message translates to:
  /// **'Add New Recipe'**
  String get addFertilizerButton;

  /// No description provided for @fertilizerNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get fertilizerNameFieldLabel;

  /// No description provided for @fertilizerCategoryFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fertilizerCategoryFieldLabel;

  /// No description provided for @fertilizerInstructionsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Preparation Steps'**
  String get fertilizerInstructionsFieldLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @searchFertilizerHint.
  ///
  /// In en, this message translates to:
  /// **'Search DIY plant food recipes...'**
  String get searchFertilizerHint;

  /// No description provided for @noFertilizersFound.
  ///
  /// In en, this message translates to:
  /// **'No matching recipes found.'**
  String get noFertilizersFound;

  /// No description provided for @serverUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your internet connection.'**
  String get serverUnreachable;

  /// No description provided for @maintainanceHeaderSubtitleForm.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your plant to generate a custom care schedule.'**
  String get maintainanceHeaderSubtitleForm;

  /// No description provided for @maintainanceHeaderSubtitleResult.
  ///
  /// In en, this message translates to:
  /// **'Here is your plant\'s personalized care roadmap.'**
  String get maintainanceHeaderSubtitleResult;

  /// No description provided for @nameOfPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant Nickname'**
  String get nameOfPlantLabel;

  /// No description provided for @nameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Fernie, Big Leaf'**
  String get nameFieldHint;

  /// No description provided for @typesOfPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant Type'**
  String get typesOfPlantLabel;

  /// No description provided for @typesFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Succulent, Monstera, Aquatic'**
  String get typesFieldHint;

  /// No description provided for @plantAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'What stage is your plant in?'**
  String get plantAgeLabel;

  /// No description provided for @ageFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Seedling, Mature, Sprout...'**
  String get ageFieldHint;

  /// No description provided for @createRoadmapButton.
  ///
  /// In en, this message translates to:
  /// **'Generate Care Roadmap'**
  String get createRoadmapButton;

  /// No description provided for @yourPlantNeeds.
  ///
  /// In en, this message translates to:
  /// **'Your \'{plantName}\' needs roughly {amount} ml of water daily. Here is your ideal watering schedule:'**
  String yourPlantNeeds(String plantName, int amount);

  /// No description provided for @setAlarmButton.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setAlarmButton;

  /// No description provided for @tipsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip: {tips}'**
  String tipsLabel(String tips);

  /// No description provided for @weatherTipHot.
  ///
  /// In en, this message translates to:
  /// **'High heat expected! Give your plant at least {waterMl} ml of water today.'**
  String weatherTipHot(int waterMl);

  /// No description provided for @weatherTipCold.
  ///
  /// In en, this message translates to:
  /// **'Chilly weather ahead—cut back on watering to prevent root rot.'**
  String get weatherTipCold;

  /// No description provided for @weatherTipWetOutside.
  ///
  /// In en, this message translates to:
  /// **'It\'s rainy outside—let nature water your outdoor plants today.'**
  String get weatherTipWetOutside;

  /// No description provided for @diseasesDetectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Plant Health\nScanner'**
  String get diseasesDetectionHeader;

  /// No description provided for @diseasesDetectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo for an instant health diagnosis.'**
  String get diseasesDetectionSubtitle;

  /// No description provided for @openCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get openCameraButton;

  /// No description provided for @cureLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended Treatment: {cure}'**
  String cureLabel(String cure);

  /// No description provided for @addToLogButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Health Log'**
  String get addToLogButton;

  /// No description provided for @buyFertilizerButton.
  ///
  /// In en, this message translates to:
  /// **'Shop Plant Food'**
  String get buyFertilizerButton;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your plant\'s best friend.'**
  String get appTagline;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @continueShoppingButton.
  ///
  /// In en, this message translates to:
  /// **'Keep Browsing'**
  String get continueShoppingButton;

  /// No description provided for @addToCartButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCartButton;

  /// No description provided for @logOutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutButton;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @onLabel.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get onLabel;

  /// No description provided for @offLabel.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Growing updates...'**
  String get loadingLabel;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your plants missed you!'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to PlantPal?'**
  String get noAccountPrompt;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerLink;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @emailSignInUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Email sign-in is temporarily unavailable. Please continue with Google.'**
  String get emailSignInUnavailable;

  /// No description provided for @signingInLabel.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingInLabel;

  /// No description provided for @continueWithGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogleButton;

  /// No description provided for @continueAsGuestButton.
  ///
  /// In en, this message translates to:
  /// **'Explore as Guest (Debug)'**
  String get continueAsGuestButton;

  /// No description provided for @careMetricWater.
  ///
  /// In en, this message translates to:
  /// **'Watering'**
  String get careMetricWater;

  /// No description provided for @careMetricSunlight.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get careMetricSunlight;

  /// No description provided for @careMetricTemp.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get careMetricTemp;

  /// No description provided for @careMetricFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get careMetricFertilizer;

  /// No description provided for @careMetricHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get careMetricHumidity;

  /// No description provided for @careGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Care Playbook'**
  String get careGuideTitle;

  /// No description provided for @careChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Plant Quest'**
  String get careChallengeTitle;

  /// No description provided for @careChallengeDoneMessage.
  ///
  /// In en, this message translates to:
  /// **'All done! Your green family is thriving.'**
  String get careChallengeDoneMessage;

  /// No description provided for @careEssentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Essentials'**
  String get careEssentialsTitle;

  /// No description provided for @careProTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Expert Insights'**
  String get careProTipsTitle;

  /// No description provided for @careCommonProblemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get careCommonProblemsTitle;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is feeling empty'**
  String get cartEmptyTitle;

  /// No description provided for @proceedToCheckoutButton.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckoutButton;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @shippingInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get shippingInfoTitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @shippingAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddressLabel;

  /// No description provided for @deliveryMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Method'**
  String get deliveryMethodLabel;

  /// No description provided for @orderSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummaryTitle;

  /// No description provided for @continueToPaymentButton.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPaymentButton;

  /// Auto-extracted UI string for checkoutDeliveryEtaFee
  ///
  /// In en, this message translates to:
  /// **'{eta} • {fee}'**
  String checkoutDeliveryEtaFee(String eta, String fee);

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderConfirmedTitle;

  /// No description provided for @orderConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with PlantPal!\nYour goodies are on their way.'**
  String get orderConfirmedBody;

  /// No description provided for @orderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderIdLabel;

  /// Auto-extracted UI string for orderIdValue
  ///
  /// In en, this message translates to:
  /// **'#{orderId}'**
  String orderIdValue(String orderId);

  /// No description provided for @estimatedDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDeliveryLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Prepping your order'**
  String get statusProcessing;

  /// No description provided for @backToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeButton;

  /// No description provided for @recipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe Details'**
  String get recipeTitle;

  /// No description provided for @recipeNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Recipe could not be found.'**
  String get recipeNotFoundMessage;

  /// No description provided for @ingredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsTitle;

  /// No description provided for @preparationTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Prepare'**
  String get preparationTitle;

  /// No description provided for @applicationTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Apply'**
  String get applicationTitle;

  /// No description provided for @benefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Benefits'**
  String get benefitsTitle;

  /// No description provided for @safetyTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Precautions'**
  String get safetyTipsTitle;

  /// No description provided for @fertilizerMakingTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Food Lab'**
  String get fertilizerMakingTitle;

  /// No description provided for @noRecipesFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFoundTitle;

  /// Auto-extracted UI string for noRecipesFoundBody
  ///
  /// In en, this message translates to:
  /// **'No plant food recipes match \"{query}\".'**
  String noRecipesFoundBody(String query);

  /// No description provided for @fertilizerSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover easy DIY plant nutrients'**
  String get fertilizerSearchSubtitle;

  /// Auto-extracted UI string for nutrientLabel
  ///
  /// In en, this message translates to:
  /// **'Key Nutrient: {nutrient}'**
  String nutrientLabel(String nutrient);

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Badges & Milestones'**
  String get achievementsTitle;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! No new notifications.'**
  String get noNotificationsMessage;

  /// Auto-extracted UI string for mascotThirstyMessage
  ///
  /// In en, this message translates to:
  /// **'{mascotName} is looking thirsty—time for a drink!'**
  String mascotThirstyMessage(String mascotName);

  /// No description provided for @uploadPlantPhotoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Snap or upload a photo'**
  String get uploadPlantPhotoPrompt;

  /// No description provided for @myPlantsMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'My Garden'**
  String get myPlantsMenuLabel;

  /// No description provided for @aiDoctorMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Plant Doctor'**
  String get aiDoctorMenuLabel;

  /// No description provided for @fertilizerRecipesMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'DIY Plant Food'**
  String get fertilizerRecipesMenuLabel;

  /// No description provided for @maintenanceMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Care Schedules'**
  String get maintenanceMenuLabel;

  /// No description provided for @shopMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Garden Shop'**
  String get shopMenuLabel;

  /// No description provided for @cameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraLabel;

  /// Auto-extracted UI string for pointsBalanceLabel
  ///
  /// In en, this message translates to:
  /// **'{points} pts ({taka} ৳)'**
  String pointsBalanceLabel(String points, String taka);

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessTitle;

  /// Auto-extracted UI string for paymentSuccessBody
  ///
  /// In en, this message translates to:
  /// **'Your payment of {amount} via {method} was completed successfully.'**
  String paymentSuccessBody(String amount, String method);

  /// No description provided for @viewOrderButton.
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get viewOrderButton;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailedTitle;

  /// No description provided for @paymentFailedBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t process your payment. Please try again or use another payment option.'**
  String get paymentFailedBody;

  /// No description provided for @changePaymentMethodButton.
  ///
  /// In en, this message translates to:
  /// **'Change Payment Method'**
  String get changePaymentMethodButton;

  /// No description provided for @tryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainButton;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @secureCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Checkout'**
  String get secureCheckoutTitle;

  /// No description provided for @secureCheckoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your transaction details are protected with bank-grade security.'**
  String get secureCheckoutBody;

  /// No description provided for @selectPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethodTitle;

  /// No description provided for @orderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get orderTotalLabel;

  /// No description provided for @processingLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing transaction...'**
  String get processingLabel;

  /// Auto-extracted UI string for payButtonLabel
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payButtonLabel(String amount);

  /// Auto-extracted UI string for plantAddedSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} has joined your garden! 🌱'**
  String plantAddedSnackbar(String name);

  /// No description provided for @addPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Plant'**
  String get addPlantTitle;

  /// No description provided for @addPlantPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get addPlantPhotoLabel;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Leafy, Monster'**
  String get nicknameHint;

  /// No description provided for @plantSpeciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant Species'**
  String get plantSpeciesLabel;

  /// No description provided for @speciesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Monstera Deliciosa'**
  String get speciesHint;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sunroom, Bedside Table'**
  String get locationHint;

  /// No description provided for @sunlightMediumOption.
  ///
  /// In en, this message translates to:
  /// **'Filtered Light'**
  String get sunlightMediumOption;

  /// No description provided for @waterFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Watering interval (days)'**
  String get waterFrequencyLabel;

  /// No description provided for @wateredTodayCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Watered today'**
  String get wateredTodayCheckbox;

  /// No description provided for @autoFillAiScanButton.
  ///
  /// In en, this message translates to:
  /// **'Identify Automatically with AI'**
  String get autoFillAiScanButton;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving to garden...'**
  String get savingLabel;

  /// No description provided for @savePlantButton.
  ///
  /// In en, this message translates to:
  /// **'Save Plant'**
  String get savePlantButton;

  /// No description provided for @tomorrowLabel.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrowLabel;

  /// No description provided for @laterThisWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Coming Up This Week'**
  String get laterThisWeekLabel;

  /// No description provided for @careCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Calendar'**
  String get careCalendarTitle;

  /// No description provided for @noCareTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming care tasks'**
  String get noCareTasksTitle;

  /// No description provided for @noCareTasksBody.
  ///
  /// In en, this message translates to:
  /// **'Add a plant to build your watering calendar.'**
  String get noCareTasksBody;

  /// Auto-extracted UI string for careTaskWater
  ///
  /// In en, this message translates to:
  /// **'Water {name}'**
  String careTaskWater(String name);

  /// Auto-extracted UI string for careTaskFertilize
  ///
  /// In en, this message translates to:
  /// **'Feed {name}'**
  String careTaskFertilize(String name);

  /// No description provided for @allCaughtUpTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all done!'**
  String get allCaughtUpTitle;

  /// No description provided for @allCaughtUpBody.
  ///
  /// In en, this message translates to:
  /// **'Your leafy crew is happy and hydrated.'**
  String get allCaughtUpBody;

  /// No description provided for @myPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Green Sanctuary'**
  String get myPlantsTitle;

  /// No description provided for @searchPlantsHint.
  ///
  /// In en, this message translates to:
  /// **'Find a plant in your garden...'**
  String get searchPlantsHint;

  /// No description provided for @statPlants.
  ///
  /// In en, this message translates to:
  /// **'Total Plants'**
  String get statPlants;

  /// No description provided for @statHealth.
  ///
  /// In en, this message translates to:
  /// **'Overall Health'**
  String get statHealth;

  /// No description provided for @statWaterToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get statWaterToday;

  /// No description provided for @noPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your sanctuary is empty'**
  String get noPlantsTitle;

  /// No description provided for @noPlantsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to welcome your very first plant!'**
  String get noPlantsBody;

  /// Auto-extracted UI string for plantWateredSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} is hydrated and happy! 💧'**
  String plantWateredSnackbar(String name);

  /// No description provided for @deletePlantConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Plant?'**
  String get deletePlantConfirmTitle;

  /// Auto-extracted UI string for deletePlantConfirmBody
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed from your garden collection.'**
  String deletePlantConfirmBody(String name);

  /// No description provided for @plantFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plantFallbackTitle;

  /// No description provided for @plantNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that plant.'**
  String get plantNotFoundMessage;

  /// No description provided for @markAsWateredTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark as watered'**
  String get markAsWateredTooltip;

  /// No description provided for @deletePlantMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Remove plant'**
  String get deletePlantMenuItem;

  /// No description provided for @todaysCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Routine'**
  String get todaysCareTitle;

  /// Auto-extracted UI string for plantWaterLevelLabel
  ///
  /// In en, this message translates to:
  /// **'Moisture Level: {level}'**
  String plantWaterLevelLabel(String level);

  /// No description provided for @noFertilizerNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'No feeding schedule set yet'**
  String get noFertilizerNoteMessage;

  /// Auto-extracted UI string for plantFertilizeNoteLabel
  ///
  /// In en, this message translates to:
  /// **'Feeding Tip: {note}'**
  String plantFertilizeNoteLabel(String note);

  /// Auto-extracted UI string for plantLastScanLabel
  ///
  /// In en, this message translates to:
  /// **'Last check-up: {when}'**
  String plantLastScanLabel(String when);

  /// No description provided for @scanAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Check-up'**
  String get scanAgainButton;

  /// No description provided for @askAiDoctorButton.
  ///
  /// In en, this message translates to:
  /// **'Consult AI Doctor'**
  String get askAiDoctorButton;

  /// No description provided for @plantHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Journal'**
  String get plantHistoryTitle;

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noActivityTitle;

  /// No description provided for @noActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Scan or water a plant to kick off its growth journal!'**
  String get noActivityBody;

  /// No description provided for @historyScanEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} received an AI check-up'**
  String historyScanEntry(String name);

  /// No description provided for @historyWateredEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} was watered'**
  String historyWateredEntry(String name);

  /// No description provided for @historyFertilizedEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} was fertilized'**
  String historyFertilizedEntry(String name);

  /// No description provided for @historySkippedEntry.
  ///
  /// In en, this message translates to:
  /// **'Watering was postponed for {name}'**
  String historySkippedEntry(String name);

  /// No description provided for @historyNoteEntry.
  ///
  /// In en, this message translates to:
  /// **'A note was added for {name}'**
  String historyNoteEntry(String name);

  /// No description provided for @plantRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get plantRecentActivityTitle;

  /// No description provided for @careStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Care streak'**
  String get careStreakLabel;

  /// No description provided for @careStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String careStreakDays(int days);

  /// No description provided for @plantNoActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded yet.'**
  String get plantNoActivityYet;

  /// No description provided for @gardenHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'Garden history'**
  String get gardenHistoryButton;

  /// No description provided for @activityWateredLabel.
  ///
  /// In en, this message translates to:
  /// **'Watered'**
  String get activityWateredLabel;

  /// No description provided for @activityFertilizedLabel.
  ///
  /// In en, this message translates to:
  /// **'Fertilized'**
  String get activityFertilizedLabel;

  /// No description provided for @activityScanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant scan'**
  String get activityScanLabel;

  /// No description provided for @activitySkippedLabel.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get activitySkippedLabel;

  /// No description provided for @activityNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get activityNoteLabel;

  /// No description provided for @skipSnoozeTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip or snooze watering'**
  String get skipSnoozeTitle;

  /// No description provided for @skipReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get skipReasonLabel;

  /// No description provided for @skipSoilWetReason.
  ///
  /// In en, this message translates to:
  /// **'Soil is still wet'**
  String get skipSoilWetReason;

  /// No description provided for @skipRainedReason.
  ///
  /// In en, this message translates to:
  /// **'It rained'**
  String get skipRainedReason;

  /// No description provided for @skipOtherReason.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get skipOtherReason;

  /// No description provided for @skipDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze for'**
  String get skipDurationLabel;

  /// No description provided for @skipOneDay.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get skipOneDay;

  /// No description provided for @skipTwoDays.
  ///
  /// In en, this message translates to:
  /// **'2 days'**
  String get skipTwoDays;

  /// No description provided for @skipThreeDays.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get skipThreeDays;

  /// No description provided for @skipSevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get skipSevenDays;

  /// No description provided for @skipSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Watering snoozed for {days} days.'**
  String skipSavedSnackbar(int days);

  /// No description provided for @historyCreatedEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} was added to garden'**
  String historyCreatedEntry(String name);

  /// No description provided for @notScannedYetLabel.
  ///
  /// In en, this message translates to:
  /// **'Awaiting first check-up'**
  String get notScannedYetLabel;

  /// Auto-extracted UI string for healthCritical
  ///
  /// In en, this message translates to:
  /// **'{percent}% • Urgent Action Needed'**
  String healthCritical(int percent);

  /// Auto-extracted UI string for healthNeedsCare
  ///
  /// In en, this message translates to:
  /// **'{percent}% • Attention Suggested'**
  String healthNeedsCare(int percent);

  /// Auto-extracted UI string for healthHealthy
  ///
  /// In en, this message translates to:
  /// **'{percent}% • Thriving'**
  String healthHealthy(int percent);

  /// Auto-extracted UI string for healthOkay
  ///
  /// In en, this message translates to:
  /// **'{percent}% • Doing OK'**
  String healthOkay(int percent);

  /// Auto-extracted UI string for healthReasonWaterLate
  ///
  /// In en, this message translates to:
  /// **'Watering {days} days overdue'**
  String healthReasonWaterLate(int days);

  /// Auto-extracted UI string for healthReasonFertilizerLate
  ///
  /// In en, this message translates to:
  /// **'Fertilizing {days} days overdue'**
  String healthReasonFertilizerLate(int days);

  /// Auto-extracted UI string for healthReasonScanIssue
  ///
  /// In en, this message translates to:
  /// **'Check-up: {issue} ({severity})'**
  String healthReasonScanIssue(String issue, String severity);

  /// No description provided for @scanSeverityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get scanSeverityMild;

  /// No description provided for @scanSeverityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get scanSeverityModerate;

  /// No description provided for @scanSeveritySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get scanSeveritySevere;

  /// No description provided for @noCheckupHint.
  ///
  /// In en, this message translates to:
  /// **'No check-up yet. Scan this plant to see how healthy it really is.'**
  String get noCheckupHint;

  /// No description provided for @dueNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get dueNotSet;

  /// Auto-extracted UI string for dueOverdueDays
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Overdue by 1 day} other{Overdue by {days} days}}'**
  String dueOverdueDays(int days);

  /// Auto-extracted UI string for dueInDays
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String dueInDays(int days);

  /// No description provided for @statNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'Need Attention'**
  String get statNeedAttention;

  /// Auto-extracted UI string for plantWaterDueLabel
  ///
  /// In en, this message translates to:
  /// **'Watering: {when}'**
  String plantWaterDueLabel(String when);

  /// No description provided for @settingsMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenuLabel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Auto-extracted UI string for profileMemberSince
  ///
  /// In en, this message translates to:
  /// **'Plant Parent since {year}'**
  String profileMemberSince(String year);

  /// No description provided for @statAvgHealth.
  ///
  /// In en, this message translates to:
  /// **'Avg Health Score'**
  String get statAvgHealth;

  /// No description provided for @statBadges.
  ///
  /// In en, this message translates to:
  /// **'Garden Badges'**
  String get statBadges;

  /// No description provided for @quickMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Navigation'**
  String get quickMenuTitle;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get chooseLanguageTitle;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0\n\nYour intelligent plant companion—scan, care, and cultivate your home jungle with confidence.'**
  String get aboutBody;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSectionTitle;

  /// No description provided for @pushNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotificationsLabel;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates, plant tips, and announcements'**
  String get pushNotificationsSubtitle;

  /// No description provided for @wateringRemindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Watering Alerts'**
  String get wateringRemindersLabel;

  /// No description provided for @wateringRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified exact moments your plants get thirsty'**
  String get wateringRemindersSubtitle;

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSectionTitle;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  /// No description provided for @generalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSectionTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageLabel;

  /// No description provided for @aboutPlantPalLabel.
  ///
  /// In en, this message translates to:
  /// **'About PlantPal'**
  String get aboutPlantPalLabel;

  /// No description provided for @accountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of PlantPal?'**
  String get logoutConfirmBody;

  /// No description provided for @reviewsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Reviews'**
  String get reviewsSectionTitle;

  /// No description provided for @noReviewsMessage.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first plant parent to leave a review!'**
  String get noReviewsMessage;

  /// No description provided for @writeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReviewTitle;

  /// No description provided for @yourRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRatingLabel;

  /// No description provided for @reviewHintText.
  ///
  /// In en, this message translates to:
  /// **'How did this product perform for your plants?'**
  String get reviewHintText;

  /// No description provided for @submitReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReviewButton;

  /// No description provided for @categoryAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get categoryAllLabel;

  /// No description provided for @productFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productFallbackTitle;

  /// No description provided for @productNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFoundMessage;

  /// No description provided for @detailsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get detailsSectionTitle;

  /// No description provided for @descriptionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get descriptionSectionTitle;

  /// No description provided for @quantitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantitySectionTitle;

  /// Auto-extracted UI string for productQuantityFormula
  ///
  /// In en, this message translates to:
  /// **'= {qty} × {unit}'**
  String productQuantityFormula(int qty, String unit);

  /// No description provided for @buyNowButton.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNowButton;

  /// No description provided for @productReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String productReviewsCount(int count);

  /// No description provided for @productInStock.
  ///
  /// In en, this message translates to:
  /// **'{count} units left'**
  String productInStock(int count);

  /// No description provided for @shopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Curated tools and supplies for a thriving garden'**
  String get shopSubtitle;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products, tools, fertilizers...'**
  String get searchProductsHint;

  /// No description provided for @noProductsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No products found matching your search.'**
  String get noProductsFoundMessage;

  /// Auto-extracted UI string for productAddedToCartSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} added to your cart! 🛍️'**
  String productAddedToCartSnackbar(String name);

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to save it for later.'**
  String get wishlistEmptyBody;

  /// No description provided for @browseShopButton.
  ///
  /// In en, this message translates to:
  /// **'Explore the Shop'**
  String get browseShopButton;

  /// No description provided for @plantBotAnalyzingLabel.
  ///
  /// In en, this message translates to:
  /// **'PlantBot is inspecting your leaf...'**
  String get plantBotAnalyzingLabel;

  /// No description provided for @scanPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Plant'**
  String get scanPlantTitle;

  /// No description provided for @analyzingPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing leaf patterns & health...'**
  String get analyzingPlantLabel;

  /// No description provided for @chooseFromGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Choose from Photo Gallery'**
  String get chooseFromGalleryButton;

  /// No description provided for @plantIdentifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Match Found!'**
  String get plantIdentifiedTitle;

  /// No description provided for @noScanYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No active scan'**
  String get noScanYetTitle;

  /// No description provided for @noScanYetBody.
  ///
  /// In en, this message translates to:
  /// **'Take or select a photo of your plant to analyze.'**
  String get noScanYetBody;

  /// No description provided for @unknownPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Unrecognized Species'**
  String get unknownPlantLabel;

  /// No description provided for @aiHardcodedLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample Result'**
  String get aiHardcodedLabel;

  /// No description provided for @viewCareGuideButton.
  ///
  /// In en, this message translates to:
  /// **'Open Care Guide'**
  String get viewCareGuideButton;

  /// No description provided for @captionHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note or caption (optional)...'**
  String get captionHint;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask your plant question...'**
  String get chatInputHint;

  /// No description provided for @aiVisionAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Vision Diagnostics'**
  String get aiVisionAnalysisTitle;

  /// Auto-extracted UI string for diagnosisProblemLabel
  ///
  /// In en, this message translates to:
  /// **'Detected Concern: {issue}'**
  String diagnosisProblemLabel(String issue);

  /// Auto-extracted UI string for diagnosisConfidenceSeverity
  ///
  /// In en, this message translates to:
  /// **'Confidence: {confidence} | Severity: {severity}'**
  String diagnosisConfidenceSeverity(String confidence, String severity);

  /// No description provided for @treatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment:'**
  String get treatmentLabel;

  /// No description provided for @recommendedFertilizerLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended Fertilizer:'**
  String get recommendedFertilizerLabel;

  /// No description provided for @shopProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Products:'**
  String get shopProductsLabel;

  /// Auto-extracted UI string for bulletItem
  ///
  /// In en, this message translates to:
  /// **'• {item}'**
  String bulletItem(String item);

  /// No description provided for @aiDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'AI guidance only — not a guaranteed diagnosis. Check with a local plant expert for serious issues.'**
  String get aiDisclaimerText;

  /// No description provided for @chatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m PlantBot.\nHow can I help your plants today?'**
  String get chatWelcomeMessage;

  /// No description provided for @chatSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Why are my leaves yellow?'**
  String get chatSuggestion1;

  /// No description provided for @chatSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Homemade Banana Fertilizer'**
  String get chatSuggestion2;

  /// No description provided for @chatSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Treat Leaf Spot'**
  String get chatSuggestion3;

  /// No description provided for @chatRateLimitError.
  ///
  /// In en, this message translates to:
  /// **'Free-tier rate limit reached. Please wait 10 seconds and try again.'**
  String get chatRateLimitError;

  /// No description provided for @signInRequiredChatMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with Google to chat with PlantBot.'**
  String get signInRequiredChatMessage;

  /// No description provided for @connectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'I am having trouble connecting to my plant knowledge base. Please check your connection.'**
  String get connectionErrorMessage;

  /// No description provided for @genericChatErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'I had trouble with that request. Please try again!'**
  String get genericChatErrorMessage;

  /// No description provided for @scanRateLimitError.
  ///
  /// In en, this message translates to:
  /// **'Rate limit reached. Please wait 10 seconds and try again.'**
  String get scanRateLimitError;

  /// No description provided for @signInRequiredScanMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with Google to scan plants.'**
  String get signInRequiredScanMessage;

  /// No description provided for @scanAnalysisErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'I couldn\'t analyze that photo. Please try again.'**
  String get scanAnalysisErrorMessage;

  /// No description provided for @plantDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Details'**
  String get plantDetailsTitle;

  /// No description provided for @careSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Summary'**
  String get careSummaryTitle;

  /// No description provided for @actionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsTitle;

  /// No description provided for @lastWateredLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Watered'**
  String get lastWateredLabel;

  /// No description provided for @nextWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Watering'**
  String get nextWaterLabel;

  /// No description provided for @sunlightLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get sunlightLabel;

  /// No description provided for @neverWateredLabel.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get neverWateredLabel;

  /// No description provided for @wateredTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get wateredTodayLabel;

  /// No description provided for @daysAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgoLabel(int days);

  /// No description provided for @waterNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Water now!'**
  String get waterNowLabel;

  /// No description provided for @daysLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'In {days}d'**
  String daysLeftLabel(int days);

  /// No description provided for @unknownSpeciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown species'**
  String get unknownSpeciesLabel;

  /// No description provided for @noNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'No nickname'**
  String get noNicknameLabel;

  /// No description provided for @markWateredButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as Watered'**
  String get markWateredButton;

  /// No description provided for @editPlantButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Plant'**
  String get editPlantButton;

  /// No description provided for @markedWateredSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} has been watered 💧'**
  String markedWateredSnackbar(String name);

  /// No description provided for @needsWaterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Needs water'**
  String get needsWaterTooltip;

  /// No description provided for @emptyPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'No plants yet'**
  String get emptyPlantsTitle;

  /// No description provided for @emptyPlantsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first plant.'**
  String get emptyPlantsBody;

  /// No description provided for @addFirstPlantButton.
  ///
  /// In en, this message translates to:
  /// **'Add your first plant'**
  String get addFirstPlantButton;

  /// No description provided for @plantsGridHeader.
  ///
  /// In en, this message translates to:
  /// **'My Plants'**
  String get plantsGridHeader;

  /// No description provided for @editPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Plant'**
  String get editPlantTitle;

  /// No description provided for @plantSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Plant saved successfully.'**
  String get plantSavedSnackbar;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this plant?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @deletePlantButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Plant'**
  String get deletePlantButton;

  /// No description provided for @changePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhotoLabel;

  /// No description provided for @settingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSectionTitle;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @helpLabel.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @profileStatPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get profileStatPlants;

  /// No description provided for @profileStatOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profileStatOrders;

  /// No description provided for @profileStatPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profileStatPoints;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @allCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategoryLabel;

  /// No description provided for @noProductsFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFoundTitle;

  /// No description provided for @noScanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'No scan yet'**
  String get noScanResultTitle;

  /// No description provided for @noScanResultBody.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a plant photo first.'**
  String get noScanResultBody;

  /// No description provided for @defaultDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Plant Parent'**
  String get defaultDisplayName;

  /// No description provided for @refreshPriceButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh Price via AI'**
  String get refreshPriceButton;

  /// No description provided for @checkingPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking live price...'**
  String get checkingPriceLabel;

  /// No description provided for @aiPriceRefreshedLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Price Check'**
  String get aiPriceRefreshedLabel;

  /// No description provided for @priceCheckedAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'Checked {timeAgo}'**
  String priceCheckedAgoLabel(String timeAgo);

  /// No description provided for @possiblyOutOfStockLabel.
  ///
  /// In en, this message translates to:
  /// **'May be out of stock'**
  String get possiblyOutOfStockLabel;

  /// No description provided for @priceRefreshFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch live price'**
  String get priceRefreshFailedLabel;

  /// No description provided for @refreshAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh again'**
  String get refreshAgainLabel;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @justNowLabel.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNowLabel;

  /// No description provided for @minutesAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgoLabel(int count);

  /// No description provided for @hoursAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgoLabel(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navAiDoctor.
  ///
  /// In en, this message translates to:
  /// **'AI Doctor'**
  String get navAiDoctor;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @myOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrdersLabel;

  /// No description provided for @noOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersTitle;

  /// No description provided for @noOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'Orders you place will show up here.'**
  String get noOrdersBody;

  /// No description provided for @markAsFertilizedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark as fertilized'**
  String get markAsFertilizedTooltip;

  /// No description provided for @plantFertilizedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} has been fed!'**
  String plantFertilizedSnackbar(String name);

  /// No description provided for @chatHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistoryTooltip;

  /// No description provided for @chatSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your chats'**
  String get chatSessionsTitle;

  /// No description provided for @chatNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNewChat;

  /// No description provided for @chatSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chatSessionsToday;

  /// No description provided for @chatSessionsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get chatSessionsYesterday;

  /// No description provided for @chatSessionsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get chatSessionsEarlier;

  /// No description provided for @chatSessionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get chatSessionsEmptyTitle;

  /// No description provided for @chatSessionsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation and it will show up here.'**
  String get chatSessionsEmptyBody;

  /// No description provided for @chatUntitledSession.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get chatUntitledSession;

  /// No description provided for @chatDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this chat?'**
  String get chatDeleteConfirmTitle;

  /// No description provided for @chatDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This conversation will be permanently removed.'**
  String get chatDeleteConfirmBody;

  /// No description provided for @chatDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the chat. Please try again.'**
  String get chatDeleteFailed;

  /// No description provided for @chatLoadHistoryError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this chat.'**
  String get chatLoadHistoryError;

  /// No description provided for @chatStopTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop generating'**
  String get chatStopTooltip;

  /// No description provided for @chatScanContextRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove scan from this chat'**
  String get chatScanContextRemove;

  /// No description provided for @chatPhotoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Photo unavailable. Tap to retry.'**
  String get chatPhotoUnavailable;

  /// No description provided for @chatScanPrefill.
  ///
  /// In en, this message translates to:
  /// **'My plant shows {issue}. What should I do?'**
  String chatScanPrefill(String issue);

  /// No description provided for @filterNeedsWater.
  ///
  /// In en, this message translates to:
  /// **'Needs water'**
  String get filterNeedsWater;

  /// No description provided for @filterNeedsFeeding.
  ///
  /// In en, this message translates to:
  /// **'Needs feeding'**
  String get filterNeedsFeeding;

  /// No description provided for @filterNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get filterNeedsAttention;

  /// No description provided for @plantsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plant} other{{count} plants}}'**
  String plantsCountLabel(int count);

  /// No description provided for @groupByLocation.
  ///
  /// In en, this message translates to:
  /// **'Group by location'**
  String get groupByLocation;

  /// No description provided for @noLocationGroup.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get noLocationGroup;

  /// No description provided for @waterAllDueButton.
  ///
  /// In en, this message translates to:
  /// **'Water all due ({count})'**
  String waterAllDueButton(int count);

  /// No description provided for @waterAllDoneSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Watered {count} plants 💧 +{points} points'**
  String waterAllDoneSnackbar(int count, int points);

  /// No description provided for @statusWaterToday.
  ///
  /// In en, this message translates to:
  /// **'Water today'**
  String get statusWaterToday;

  /// No description provided for @statusFeedDue.
  ///
  /// In en, this message translates to:
  /// **'Feeding due'**
  String get statusFeedDue;

  /// No description provided for @statusNextWater.
  ///
  /// In en, this message translates to:
  /// **'Next: {day}'**
  String statusNextWater(String day);

  /// No description provided for @statusWatered.
  ///
  /// In en, this message translates to:
  /// **'Watered ✓'**
  String get statusWatered;

  /// No description provided for @waterPlantTooltip.
  ///
  /// In en, this message translates to:
  /// **'Water {name}'**
  String waterPlantTooltip(String name);

  /// No description provided for @wateredUndoSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} watered 💧'**
  String wateredUndoSnackbar(String name);

  /// No description provided for @undoButton.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoButton;

  /// No description provided for @pointsEarned.
  ///
  /// In en, this message translates to:
  /// **'+{points} points'**
  String pointsEarned(int points);

  /// No description provided for @emptyGardenBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a photo and we will identify it for you, or add it by hand.'**
  String get emptyGardenBody;

  /// No description provided for @scanToAddButton.
  ///
  /// In en, this message translates to:
  /// **'Scan to add'**
  String get scanToAddButton;

  /// No description provided for @addManuallyButton.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManuallyButton;

  /// No description provided for @noMatchingPlants.
  ///
  /// In en, this message translates to:
  /// **'No plants match this filter'**
  String get noMatchingPlants;

  /// No description provided for @healthBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Health breakdown'**
  String get healthBreakdownTitle;

  /// No description provided for @healthBreakdownBase.
  ///
  /// In en, this message translates to:
  /// **'Perfect health'**
  String get healthBreakdownBase;

  /// No description provided for @healthBreakdownNoIssues.
  ///
  /// In en, this message translates to:
  /// **'Nothing is lowering the health of this plant.'**
  String get healthBreakdownNoIssues;

  /// No description provided for @healthBreakdownTotal.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get healthBreakdownTotal;

  /// No description provided for @nextUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextUpTitle;

  /// No description provided for @nextUpWaterNow.
  ///
  /// In en, this message translates to:
  /// **'Water now'**
  String get nextUpWaterNow;

  /// No description provided for @nextUpWaterNowMl.
  ///
  /// In en, this message translates to:
  /// **'Water now · {ml} ml'**
  String nextUpWaterNowMl(int ml);

  /// No description provided for @nextUpFeedNow.
  ///
  /// In en, this message translates to:
  /// **'Fertilize now'**
  String get nextUpFeedNow;

  /// No description provided for @nextUpAllDone.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get nextUpAllDone;

  /// No description provided for @nextUpNextWater.
  ///
  /// In en, this message translates to:
  /// **'Next watering: {when}'**
  String nextUpNextWater(String when);

  /// No description provided for @nextUpWaterEarly.
  ///
  /// In en, this message translates to:
  /// **'Water early'**
  String get nextUpWaterEarly;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Care schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get scheduleWater;

  /// No description provided for @scheduleFertilize.
  ///
  /// In en, this message translates to:
  /// **'Fertilize'**
  String get scheduleFertilize;

  /// No description provided for @scheduleLast.
  ///
  /// In en, this message translates to:
  /// **'Last: {when}'**
  String scheduleLast(String when);

  /// No description provided for @scheduleNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {when}'**
  String scheduleNext(String when);

  /// No description provided for @scheduleEvery.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Every day} other{Every {days} days}}'**
  String scheduleEvery(int days);

  /// No description provided for @lastNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get lastNever;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;

  /// No description provided for @careTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Care tips'**
  String get careTipsTitle;

  /// No description provided for @aiDoctorButton.
  ///
  /// In en, this message translates to:
  /// **'AI Doctor'**
  String get aiDoctorButton;

  /// No description provided for @addStepPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get addStepPhoto;

  /// No description provided for @addStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get addStepDetails;

  /// No description provided for @addStepPlan.
  ///
  /// In en, this message translates to:
  /// **'Care plan'**
  String get addStepPlan;

  /// No description provided for @addStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {n} of {total}'**
  String addStepProgress(int n, int total);

  /// No description provided for @addPhotoStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a photo'**
  String get addPhotoStepTitle;

  /// No description provided for @addPhotoStepBody.
  ///
  /// In en, this message translates to:
  /// **'Our AI botanist identifies your plant and fills in its care details.'**
  String get addPhotoStepBody;

  /// No description provided for @addIdentifyingLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing with AI Botanist...'**
  String get addIdentifyingLabel;

  /// No description provided for @addEnterManually.
  ///
  /// In en, this message translates to:
  /// **'Skip, I will enter the details'**
  String get addEnterManually;

  /// No description provided for @identifiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Identified as {species}! Details filled in.'**
  String identifiedSnackbar(String species);

  /// No description provided for @identifyFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Could not identify the plant. You can enter the details yourself.'**
  String get identifyFailedSnackbar;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @reviewPlanButton.
  ///
  /// In en, this message translates to:
  /// **'Review care plan'**
  String get reviewPlanButton;

  /// No description provided for @locationIndoor.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get locationIndoor;

  /// No description provided for @locationBalcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get locationBalcony;

  /// No description provided for @locationOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get locationOutdoor;

  /// No description provided for @lightLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lightLow;

  /// No description provided for @lightMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get lightMedium;

  /// No description provided for @lightBright.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get lightBright;

  /// No description provided for @stageSeedling.
  ///
  /// In en, this message translates to:
  /// **'Seedling'**
  String get stageSeedling;

  /// No description provided for @stageYoung.
  ///
  /// In en, this message translates to:
  /// **'Young'**
  String get stageYoung;

  /// No description provided for @stageMature.
  ///
  /// In en, this message translates to:
  /// **'Mature'**
  String get stageMature;

  /// No description provided for @notYetChip.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYetChip;

  /// No description provided for @pickDateChip.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDateChip;

  /// No description provided for @planPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your care plan'**
  String get planPreviewTitle;

  /// No description provided for @planWaterAmount.
  ///
  /// In en, this message translates to:
  /// **'About {ml} ml each time'**
  String planWaterAmount(int ml);

  /// No description provided for @planFirstWatering.
  ///
  /// In en, this message translates to:
  /// **'First watering'**
  String get planFirstWatering;

  /// No description provided for @planFeedingNote.
  ///
  /// In en, this message translates to:
  /// **'A feeding schedule is created automatically when you save.'**
  String get planFeedingNote;

  /// No description provided for @planEditDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get planEditDetails;

  /// No description provided for @addAnotherButton.
  ///
  /// In en, this message translates to:
  /// **'Add another'**
  String get addAnotherButton;

  /// No description provided for @viewPlantButton.
  ///
  /// In en, this message translates to:
  /// **'View plant'**
  String get viewPlantButton;

  /// No description provided for @firstSproutUnlocked.
  ///
  /// In en, this message translates to:
  /// **'First Sprout unlocked!'**
  String get firstSproutUnlocked;

  /// No description provided for @scanLastTitle.
  ///
  /// In en, this message translates to:
  /// **'Last check-up'**
  String get scanLastTitle;

  /// No description provided for @scanHealthyTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking healthy'**
  String get scanHealthyTitle;

  /// No description provided for @scanSeverityNone.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get scanSeverityNone;

  /// No description provided for @scanTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get scanTreatmentTitle;

  /// No description provided for @scanCareTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Care tip'**
  String get scanCareTipTitle;

  /// No description provided for @scanMarkTreated.
  ///
  /// In en, this message translates to:
  /// **'Mark treated'**
  String get scanMarkTreated;

  /// No description provided for @scanTreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Treated {date}'**
  String scanTreatedOn(String date);

  /// No description provided for @scanTreatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Marked as treated. Health updates now.'**
  String get scanTreatedSnackbar;

  /// No description provided for @scanFindFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Find fertilizer: {name}'**
  String scanFindFertilizer(String name);

  /// No description provided for @scanChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} steps done'**
  String scanChecklistProgress(int done, int total);

  /// No description provided for @plantPlacementLabel.
  ///
  /// In en, this message translates to:
  /// **'Where does it live?'**
  String get plantPlacementLabel;

  /// No description provided for @weatherRainSkipTip.
  ///
  /// In en, this message translates to:
  /// **'It\'s raining, so {name} can skip watering today.'**
  String weatherRainSkipTip(String name);

  /// No description provided for @weatherRainSkipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip today'**
  String get weatherRainSkipButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
