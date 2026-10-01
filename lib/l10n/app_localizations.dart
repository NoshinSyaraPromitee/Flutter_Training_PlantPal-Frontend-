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
  /// **'Grow with confidence'**
  String get splashTagline;

  /// No description provided for @homeHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s care for\nyour plants'**
  String get homeHeaderTitle;

  /// No description provided for @homeHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnose, feed, and grow with confidence.'**
  String get homeHeaderSubtitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning! ╬ô├┐├çΓê⌐Γòò├à Ready to check on your plants?'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon! Γëí╞Æ├«├▒Γê⌐Γòò├à How are your plants doing?'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening! Γëí╞Æ├«├Ñ Time for one last check-in.'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Still up? Γëí╞Æ├«├û Your plants are resting too.'**
  String get greetingNight;

  /// No description provided for @greetingPlantThirsty.
  ///
  /// In en, this message translates to:
  /// **'Γëí╞Æ├«ΓûÆ One of your plants is thirsty today!'**
  String get greetingPlantThirsty;

  /// No description provided for @greetingWeatherRain.
  ///
  /// In en, this message translates to:
  /// **'It\'s rainy out there Γëí╞Æ├«┬║Γê⌐Γòò├à ╬ô├ç├╢ skip watering outdoor plants today.'**
  String get greetingWeatherRain;

  /// No description provided for @greetingWeatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Storms nearby ╬ô┬ó├¬Γê⌐Γòò├à ╬ô├ç├╢ keep sensitive plants indoors.'**
  String get greetingWeatherThunderstorm;

  /// No description provided for @greetingWeatherSnow.
  ///
  /// In en, this message translates to:
  /// **'It\'s snowing ╬ô┬Ñ├ñΓê⌐Γòò├à ╬ô├ç├╢ bring tender plants inside.'**
  String get greetingWeatherSnow;

  /// No description provided for @greetingWeatherFog.
  ///
  /// In en, this message translates to:
  /// **'Foggy morning Γëí╞Æ├«┬╜Γê⌐Γòò├à ╬ô├ç├╢ your plants love the extra humidity.'**
  String get greetingWeatherFog;

  /// No description provided for @greetingWeatherHot.
  ///
  /// In en, this message translates to:
  /// **'It\'s {temperature}Γö¼ΓûæC out Γëí╞Æ├╢├æ ╬ô├ç├╢ your plants may need extra water.'**
  String greetingWeatherHot(int temperature);

  /// No description provided for @uploadPlantPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload your Plant\'s Photo'**
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
  /// **'Maintainance'**
  String get maintainance;

  /// No description provided for @diseaseDetectionTile.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get diseaseDetectionTile;

  /// No description provided for @fertilizerRecipesLabel.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Recipes'**
  String get fertilizerRecipesLabel;

  /// No description provided for @shopLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopLabel;

  /// No description provided for @chatWithExpertLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat with expert'**
  String get chatWithExpertLabel;

  /// No description provided for @mainMenuButton.
  ///
  /// In en, this message translates to:
  /// **'MainMenu'**
  String get mainMenuButton;

  /// No description provided for @fertilizerHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Making'**
  String get fertilizerHeaderTitle;

  /// No description provided for @fertilizerHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Homemade recipes for every growth stage.'**
  String get fertilizerHeaderSubtitle;

  /// No description provided for @addFertilizerButton.
  ///
  /// In en, this message translates to:
  /// **'Add a new Fertilizer'**
  String get addFertilizerButton;

  /// No description provided for @fertilizerNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fertilizerNameFieldLabel;

  /// No description provided for @fertilizerCategoryFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fertilizerCategoryFieldLabel;

  /// No description provided for @fertilizerInstructionsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
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
  /// **'Find your homemade fertilizer'**
  String get searchFertilizerHint;

  /// No description provided for @noFertilizersFound.
  ///
  /// In en, this message translates to:
  /// **'No fertilizers found.'**
  String get noFertilizersFound;

  /// No description provided for @serverUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Is the backend running?'**
  String get serverUnreachable;

  /// No description provided for @maintainanceHeaderSubtitleForm.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your plant to get a care plan.'**
  String get maintainanceHeaderSubtitleForm;

  /// No description provided for @maintainanceHeaderSubtitleResult.
  ///
  /// In en, this message translates to:
  /// **'Here╬ô├ç├ûs the care plan for your plant.'**
  String get maintainanceHeaderSubtitleResult;

  /// No description provided for @nameOfPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the Plant'**
  String get nameOfPlantLabel;

  /// No description provided for @nameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get nameFieldHint;

  /// No description provided for @typesOfPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Types of Plant'**
  String get typesOfPlantLabel;

  /// No description provided for @typesFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Water based, Maniplant etc'**
  String get typesFieldHint;

  /// No description provided for @plantAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'How are the plant\'s age ?'**
  String get plantAgeLabel;

  /// No description provided for @ageFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Seed, Seedlings...'**
  String get ageFieldHint;

  /// No description provided for @createRoadmapButton.
  ///
  /// In en, this message translates to:
  /// **'Create My Roadmap'**
  String get createRoadmapButton;

  /// No description provided for @yourPlantNeeds.
  ///
  /// In en, this message translates to:
  /// **'Your plant \'{plantName}\' needs around {amount} ml water daily. Here is the time table you can water your plants'**
  String yourPlantNeeds(String plantName, int amount);

  /// No description provided for @setAlarmButton.
  ///
  /// In en, this message translates to:
  /// **'Set Alarm'**
  String get setAlarmButton;

  /// No description provided for @tipsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tips: {tips}'**
  String tipsLabel(String tips);

  /// No description provided for @weatherTipHot.
  ///
  /// In en, this message translates to:
  /// **'It\'s too hot today Γëí╞Æ├╢├æ ╬ô├ç├╢ give at least {waterMl} ml water today.'**
  String weatherTipHot(int waterMl);

  /// No description provided for @weatherTipCold.
  ///
  /// In en, this message translates to:
  /// **'It\'s cold today ╬ô┬Ñ├ñΓê⌐Γòò├à ╬ô├ç├╢ water a little less to avoid root rot.'**
  String get weatherTipCold;

  /// No description provided for @weatherTipWetOutside.
  ///
  /// In en, this message translates to:
  /// **'It\'s wet outside today Γëí╞Æ├«┬║Γê⌐Γòò├à ╬ô├ç├╢ skip watering outdoor plants.'**
  String get weatherTipWetOutside;

  /// No description provided for @diseasesDetectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Diseases\nDetection'**
  String get diseasesDetectionHeader;

  /// No description provided for @diseasesDetectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo and get an instant assessment.'**
  String get diseasesDetectionSubtitle;

  /// No description provided for @openCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Open Camera to take photo'**
  String get openCameraButton;

  /// No description provided for @cureLabel.
  ///
  /// In en, this message translates to:
  /// **'Cure: {cure}'**
  String cureLabel(String cure);

  /// No description provided for @addToLogButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Log'**
  String get addToLogButton;

  /// No description provided for @buyFertilizerButton.
  ///
  /// In en, this message translates to:
  /// **'Buy Fertilizer'**
  String get buyFertilizerButton;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Garden\'s best Friend'**
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
  /// **'Continue Shopping'**
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
  /// **'Email'**
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
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Missing your buddies?'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerLink;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @emailSignInUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Email sign-in isn\'t available yet. Please continue with Google.'**
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
  /// **'Continue as guest (debug only)'**
  String get continueAsGuestButton;

  /// No description provided for @careMetricWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get careMetricWater;

  /// No description provided for @careMetricSunlight.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get careMetricSunlight;

  /// No description provided for @careMetricTemp.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get careMetricTemp;

  /// No description provided for @careMetricFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get careMetricFertilizer;

  /// No description provided for @careMetricHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get careMetricHumidity;

  /// No description provided for @careGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Guide'**
  String get careGuideTitle;

  /// No description provided for @careChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Care Challenge'**
  String get careChallengeTitle;

  /// No description provided for @careChallengeDoneMessage.
  ///
  /// In en, this message translates to:
  /// **'All done! Your plant is thriving today.'**
  String get careChallengeDoneMessage;

  /// No description provided for @careEssentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Essentials'**
  String get careEssentialsTitle;

  /// No description provided for @careProTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get careProTipsTitle;

  /// No description provided for @careCommonProblemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Problems'**
  String get careCommonProblemsTitle;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
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
  /// **'Shipping Information'**
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
  /// **'{eta} ╬ô├ç├│ {fee}'**
  String checkoutDeliveryEtaFee(String eta, String fee);

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed!'**
  String get orderConfirmedTitle;

  /// No description provided for @orderConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with PlantPal.\nYour order has been placed successfully.'**
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
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @backToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeButton;

  /// No description provided for @recipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipeTitle;

  /// No description provided for @recipeNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found.'**
  String get recipeNotFoundMessage;

  /// No description provided for @ingredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsTitle;

  /// No description provided for @preparationTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get preparationTitle;

  /// No description provided for @applicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get applicationTitle;

  /// No description provided for @benefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefitsTitle;

  /// No description provided for @safetyTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTipsTitle;

  /// No description provided for @fertilizerMakingTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Making'**
  String get fertilizerMakingTitle;

  /// No description provided for @noRecipesFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFoundTitle;

  /// Auto-extracted UI string for noRecipesFoundBody
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\".'**
  String noRecipesFoundBody(String query);

  /// No description provided for @fertilizerSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your homemade fertilizer'**
  String get fertilizerSearchSubtitle;

  /// Auto-extracted UI string for nutrientLabel
  ///
  /// In en, this message translates to:
  /// **'Nutrient: {nutrient}'**
  String nutrientLabel(String nutrient);

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'No new notifications.'**
  String get noNotificationsMessage;

  /// Auto-extracted UI string for mascotThirstyMessage
  ///
  /// In en, this message translates to:
  /// **'{mascotName} is thirsty, give him some water'**
  String mascotThirstyMessage(String mascotName);

  /// No description provided for @uploadPlantPhotoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Upload your Plant\'s Photo'**
  String get uploadPlantPhotoPrompt;

  /// No description provided for @myPlantsMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'My Plants'**
  String get myPlantsMenuLabel;

  /// No description provided for @aiDoctorMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Doctor'**
  String get aiDoctorMenuLabel;

  /// No description provided for @fertilizerRecipesMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Recipes'**
  String get fertilizerRecipesMenuLabel;

  /// No description provided for @maintenanceMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceMenuLabel;

  /// No description provided for @shopMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopMenuLabel;

  /// No description provided for @cameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraLabel;

  /// Auto-extracted UI string for pointsBalanceLabel
  ///
  /// In en, this message translates to:
  /// **'{points} points ( {taka} taka)'**
  String pointsBalanceLabel(String points, String taka);

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessTitle;

  /// Auto-extracted UI string for paymentSuccessBody
  ///
  /// In en, this message translates to:
  /// **'Your payment of {amount} via {method} was completed. Your order has been placed.'**
  String paymentSuccessBody(String amount, String method);

  /// No description provided for @viewOrderButton.
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get viewOrderButton;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailedTitle;

  /// No description provided for @paymentFailedBody.
  ///
  /// In en, this message translates to:
  /// **'We could not process your payment. Please try again or choose a different payment method.'**
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
  /// **'Secure Checkout'**
  String get secureCheckoutTitle;

  /// No description provided for @secureCheckoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your payment information is encrypted and secure.'**
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
  /// **'Processing...'**
  String get processingLabel;

  /// Auto-extracted UI string for payButtonLabel
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payButtonLabel(String amount);

  /// Auto-extracted UI string for plantAddedSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} has been added Γëí╞Æ├«ΓûÆ'**
  String plantAddedSnackbar(String name);

  /// No description provided for @addPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Plant'**
  String get addPlantTitle;

  /// No description provided for @addPlantPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Plant Photo'**
  String get addPlantPhotoLabel;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Bella'**
  String get nicknameHint;

  /// No description provided for @plantSpeciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Plant Species'**
  String get plantSpeciesLabel;

  /// No description provided for @speciesHint.
  ///
  /// In en, this message translates to:
  /// **'Monstera Deliciosa'**
  String get speciesHint;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get locationHint;

  /// No description provided for @sunlightMediumOption.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sunlightMediumOption;

  /// No description provided for @waterFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Water every (days)'**
  String get waterFrequencyLabel;

  /// No description provided for @wateredTodayCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I watered it today'**
  String get wateredTodayCheckbox;

  /// No description provided for @autoFillAiScanButton.
  ///
  /// In en, this message translates to:
  /// **'Auto Fill Using AI Scan'**
  String get autoFillAiScanButton;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
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
  /// **'Later This Week'**
  String get laterThisWeekLabel;

  /// No description provided for @careCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Calendar'**
  String get careCalendarTitle;

  /// No description provided for @noCareTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'No care tasks yet'**
  String get noCareTasksTitle;

  /// No description provided for @noCareTasksBody.
  ///
  /// In en, this message translates to:
  /// **'Add a plant to see its watering schedule.'**
  String get noCareTasksBody;

  /// Auto-extracted UI string for careTaskWater
  ///
  /// In en, this message translates to:
  /// **'Water {name}'**
  String careTaskWater(String name);

  /// Auto-extracted UI string for careTaskFertilize
  ///
  /// In en, this message translates to:
  /// **'Fertilize {name}'**
  String careTaskFertilize(String name);

  /// No description provided for @allCaughtUpTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUpTitle;

  /// No description provided for @allCaughtUpBody.
  ///
  /// In en, this message translates to:
  /// **'Your plants thank you.'**
  String get allCaughtUpBody;

  /// No description provided for @myPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Green Family'**
  String get myPlantsTitle;

  /// No description provided for @searchPlantsHint.
  ///
  /// In en, this message translates to:
  /// **'Search plants...'**
  String get searchPlantsHint;

  /// No description provided for @statPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get statPlants;

  /// No description provided for @statHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get statHealth;

  /// No description provided for @statWaterToday.
  ///
  /// In en, this message translates to:
  /// **'Water Today'**
  String get statWaterToday;

  /// No description provided for @noPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'No plants yet'**
  String get noPlantsTitle;

  /// No description provided for @noPlantsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first plant.'**
  String get noPlantsBody;

  /// Auto-extracted UI string for plantWateredSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} marked as watered Γëí╞Æ├å┬║'**
  String plantWateredSnackbar(String name);

  /// No description provided for @deletePlantConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete plant?'**
  String get deletePlantConfirmTitle;

  /// Auto-extracted UI string for deletePlantConfirmBody
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed from your collection.'**
  String deletePlantConfirmBody(String name);

  /// No description provided for @plantFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plantFallbackTitle;

  /// No description provided for @plantNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Plant not found.'**
  String get plantNotFoundMessage;

  /// No description provided for @markAsWateredTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark as watered'**
  String get markAsWateredTooltip;

  /// No description provided for @deletePlantMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Delete plant'**
  String get deletePlantMenuItem;

  /// No description provided for @todaysCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Care'**
  String get todaysCareTitle;

  /// Auto-extracted UI string for plantWaterLevelLabel
  ///
  /// In en, this message translates to:
  /// **'Water: {level}'**
  String plantWaterLevelLabel(String level);

  /// No description provided for @noFertilizerNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'No fertilizer note yet'**
  String get noFertilizerNoteMessage;

  /// Auto-extracted UI string for plantFertilizeNoteLabel
  ///
  /// In en, this message translates to:
  /// **'Fertilize: {note}'**
  String plantFertilizeNoteLabel(String note);

  /// Auto-extracted UI string for plantLastScanLabel
  ///
  /// In en, this message translates to:
  /// **'Last scan: {when}'**
  String plantLastScanLabel(String when);

  /// No description provided for @scanAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgainButton;

  /// No description provided for @askAiDoctorButton.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Doctor'**
  String get askAiDoctorButton;

  /// No description provided for @plantHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant History'**
  String get plantHistoryTitle;

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityTitle;

  /// No description provided for @noActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Scan or water a plant to get started!'**
  String get noActivityBody;

  /// No description provided for @historyScanEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} was scanned'**
  String historyScanEntry(String name);

  /// No description provided for @historyWateredEntry.
  ///
  /// In en, this message translates to:
  /// **'{name} was watered'**
  String historyWateredEntry(String name);

  /// No description provided for @notScannedYetLabel.
  ///
  /// In en, this message translates to:
  /// **'Not scanned yet'**
  String get notScannedYetLabel;

  /// Auto-extracted UI string for healthCritical
  ///
  /// In en, this message translates to:
  /// **'{percent}% ╬ô├ç├│ Critical'**
  String healthCritical(int percent);

  /// Auto-extracted UI string for healthNeedsCare
  ///
  /// In en, this message translates to:
  /// **'{percent}% ╬ô├ç├│ Needs Care'**
  String healthNeedsCare(int percent);

  /// Auto-extracted UI string for healthHealthy
  ///
  /// In en, this message translates to:
  /// **'{percent}% ╬ô├ç├│ Healthy'**
  String healthHealthy(int percent);

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
  /// **'Avg Health'**
  String get statAvgHealth;

  /// No description provided for @statBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get statBadges;

  /// No description provided for @quickMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Menu'**
  String get quickMenuTitle;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguageTitle;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0\n\nYour friendly AI gardening assistant ╬ô├ç├╢ scan, track, and care for your plants with confidence.'**
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
  /// **'General app updates and alerts'**
  String get pushNotificationsSubtitle;

  /// No description provided for @wateringRemindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Watering Reminders'**
  String get wateringRemindersLabel;

  /// No description provided for @wateringRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a plant needs water'**
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
  /// **'General'**
  String get generalSectionTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
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
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmBody;

  /// No description provided for @reviewsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsSectionTitle;

  /// No description provided for @noReviewsMessage.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to share your experience!'**
  String get noReviewsMessage;

  /// No description provided for @writeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReviewTitle;

  /// No description provided for @yourRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRatingLabel;

  /// No description provided for @reviewHintText.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this product...'**
  String get reviewHintText;

  /// No description provided for @submitReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReviewButton;

  /// No description provided for @categoryAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
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
  /// **'Details'**
  String get detailsSectionTitle;

  /// No description provided for @descriptionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionSectionTitle;

  /// No description provided for @quantitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantitySectionTitle;

  /// Auto-extracted UI string for productQuantityFormula
  ///
  /// In en, this message translates to:
  /// **'= {qty} Γö£├╣ {unit}'**
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
  /// **'{count} in stock'**
  String productInStock(int count);

  /// No description provided for @shopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your necessary gardening equipment'**
  String get shopSubtitle;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProductsHint;

  /// No description provided for @noProductsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFoundMessage;

  /// Auto-extracted UI string for productAddedToCartSnackbar
  ///
  /// In en, this message translates to:
  /// **'{name} added to cart'**
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
  /// **'Tap the heart on any product to save it here.'**
  String get wishlistEmptyBody;

  /// No description provided for @browseShopButton.
  ///
  /// In en, this message translates to:
  /// **'Browse Shop'**
  String get browseShopButton;

  /// No description provided for @plantBotAnalyzingLabel.
  ///
  /// In en, this message translates to:
  /// **'PlantBot is analyzing...'**
  String get plantBotAnalyzingLabel;

  /// No description provided for @scanPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Plant'**
  String get scanPlantTitle;

  /// No description provided for @analyzingPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your plant...'**
  String get analyzingPlantLabel;

  /// No description provided for @chooseFromGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGalleryButton;

  /// No description provided for @plantIdentifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Identified'**
  String get plantIdentifiedTitle;

  /// No description provided for @noScanYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No scan yet'**
  String get noScanYetTitle;

  /// No description provided for @noScanYetBody.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a plant photo first.'**
  String get noScanYetBody;

  /// No description provided for @unknownPlantLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown plant'**
  String get unknownPlantLabel;

  /// No description provided for @aiHardcodedLabel.
  ///
  /// In en, this message translates to:
  /// **'Hardcoded'**
  String get aiHardcodedLabel;

  /// No description provided for @viewCareGuideButton.
  ///
  /// In en, this message translates to:
  /// **'View Care Guide'**
  String get viewCareGuideButton;

  /// No description provided for @captionHint.
  ///
  /// In en, this message translates to:
  /// **'Add a caption (optional)...'**
  String get captionHint;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything...'**
  String get chatInputHint;

  /// No description provided for @aiVisionAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Vision Analysis'**
  String get aiVisionAnalysisTitle;

  /// Auto-extracted UI string for diagnosisProblemLabel
  ///
  /// In en, this message translates to:
  /// **'Problem: {issue}'**
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
  /// **'╬ô├ç├│ {item}'**
  String bulletItem(String item);

  /// No description provided for @aiDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'AI guidance only ╬ô├ç├╢ not a guaranteed diagnosis. Check with a local plant expert for serious issues.'**
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
  /// **'{name} has been watered ≡ƒÆº'**
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
