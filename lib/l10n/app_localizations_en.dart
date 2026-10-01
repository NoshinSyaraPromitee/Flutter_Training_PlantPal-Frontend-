// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MyPlantPal';

  @override
  String get splashTagline => 'Turn your thumb green.';

  @override
  String get homeHeaderTitle => 'Let\'s make your\njungle thrive';

  @override
  String get homeHeaderSubtitle =>
      'Diagnose issues, mix custom plant food, and grow with confidence.';

  @override
  String get greetingMorning =>
      'Good morning! Ready to check on your leaf babies?';

  @override
  String get greetingAfternoon =>
      'Good afternoon! How are your green companions holding up?';

  @override
  String get greetingEvening =>
      'Good evening! Time for a quick sundown check-in.';

  @override
  String get greetingNight =>
      'Still up? Rest easy—your plants are sleeping too.';

  @override
  String get greetingPlantThirsty => 'Someone\'s looking a bit parched today!';

  @override
  String get greetingWeatherRain =>
      'Rainy skies ahead—hold off on watering outdoor plants.';

  @override
  String get greetingWeatherThunderstorm =>
      'Storm\'s rolling in! Move vulnerable plants inside.';

  @override
  String get greetingWeatherSnow =>
      'Frost alert! Bring tender plants into the warm.';

  @override
  String get greetingWeatherFog =>
      'Misty morning—your tropical plants will love the humidity!';

  @override
  String greetingWeatherHot(int temperature) {
    return 'Sizzling $temperature°C today! Keep an eye out for dry soil.';
  }

  @override
  String get uploadPlantPhoto => 'Snap a photo of your plant';

  @override
  String get quickActionsLabel => 'QUICK ACTIONS';

  @override
  String get myPlantsLabel => 'My Plants';

  @override
  String get maintainance => 'Plant Care';

  @override
  String get diseaseDetectionTile => 'AI Plant Doctor';

  @override
  String get fertilizerRecipesLabel => 'DIY Plant Food';

  @override
  String get shopLabel => 'Garden Shop';

  @override
  String get chatWithExpertLabel => 'Ask an Expert';

  @override
  String get mainMenuButton => 'Main Menu';

  @override
  String get fertilizerHeaderTitle => 'DIY Plant Food Lab';

  @override
  String get fertilizerHeaderSubtitle =>
      'Nutrient-rich homemade recipes tailored for every growth stage.';

  @override
  String get addFertilizerButton => 'Add New Recipe';

  @override
  String get fertilizerNameFieldLabel => 'Recipe Name';

  @override
  String get fertilizerCategoryFieldLabel => 'Category';

  @override
  String get fertilizerInstructionsFieldLabel => 'Preparation Steps';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get searchFertilizerHint => 'Search DIY plant food recipes...';

  @override
  String get noFertilizersFound => 'No matching recipes found.';

  @override
  String get serverUnreachable =>
      'Unable to connect. Please check your internet connection.';

  @override
  String get maintainanceHeaderSubtitleForm =>
      'Tell us about your plant to generate a custom care schedule.';

  @override
  String get maintainanceHeaderSubtitleResult =>
      'Here is your plant\'s personalized care roadmap.';

  @override
  String get nameOfPlantLabel => 'Plant Nickname';

  @override
  String get nameFieldHint => 'e.g., Fernie, Big Leaf';

  @override
  String get typesOfPlantLabel => 'Plant Type';

  @override
  String get typesFieldHint => 'e.g., Succulent, Monstera, Aquatic';

  @override
  String get plantAgeLabel => 'What stage is your plant in?';

  @override
  String get ageFieldHint => 'Seedling, Mature, Sprout...';

  @override
  String get createRoadmapButton => 'Generate Care Roadmap';

  @override
  String yourPlantNeeds(String plantName, int amount) {
    return 'Your \'$plantName\' needs roughly $amount ml of water daily. Here is your ideal watering schedule:';
  }

  @override
  String get setAlarmButton => 'Set Reminder';

  @override
  String tipsLabel(String tips) {
    return 'Pro Tip: $tips';
  }

  @override
  String weatherTipHot(int waterMl) {
    return 'High heat expected! Give your plant at least $waterMl ml of water today.';
  }

  @override
  String get weatherTipCold =>
      'Chilly weather ahead—cut back on watering to prevent root rot.';

  @override
  String get weatherTipWetOutside =>
      'It\'s rainy outside—let nature water your outdoor plants today.';

  @override
  String get diseasesDetectionHeader => 'Plant Health\nScanner';

  @override
  String get diseasesDetectionSubtitle =>
      'Snap a photo for an instant health diagnosis.';

  @override
  String get openCameraButton => 'Take Photo';

  @override
  String cureLabel(String cure) {
    return 'Recommended Treatment: $cure';
  }

  @override
  String get addToLogButton => 'Add to Health Log';

  @override
  String get buyFertilizerButton => 'Shop Plant Food';

  @override
  String get appTagline => 'Your plant\'s best friend.';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get deleteButton => 'Delete';

  @override
  String get backButton => 'Back';

  @override
  String get closeButton => 'Close';

  @override
  String get continueShoppingButton => 'Keep Browsing';

  @override
  String get addToCartButton => 'Add to Cart';

  @override
  String get logOutButton => 'Log Out';

  @override
  String get todayLabel => 'Today';

  @override
  String get onLabel => 'On';

  @override
  String get offLabel => 'Off';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get locationLabel => 'Location';

  @override
  String get loadingLabel => 'Growing updates...';

  @override
  String get loginWelcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Your plants missed you!';

  @override
  String get loginButton => 'Log In';

  @override
  String get orDivider => 'OR';

  @override
  String get noAccountPrompt => 'New to PlantPal?';

  @override
  String get registerLink => 'Sign Up';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get emailSignInUnavailable =>
      'Email sign-in is temporarily unavailable. Please continue with Google.';

  @override
  String get signingInLabel => 'Signing in...';

  @override
  String get continueWithGoogleButton => 'Continue with Google';

  @override
  String get continueAsGuestButton => 'Explore as Guest (Debug)';

  @override
  String get careMetricWater => 'Watering';

  @override
  String get careMetricSunlight => 'Sunlight';

  @override
  String get careMetricTemp => 'Temperature';

  @override
  String get careMetricFertilizer => 'Nutrients';

  @override
  String get careMetricHumidity => 'Humidity';

  @override
  String get careGuideTitle => 'Plant Care Playbook';

  @override
  String get careChallengeTitle => 'Today\'s Plant Quest';

  @override
  String get careChallengeDoneMessage =>
      'All done! Your green family is thriving.';

  @override
  String get careEssentialsTitle => 'Care Essentials';

  @override
  String get careProTipsTitle => 'Expert Insights';

  @override
  String get careCommonProblemsTitle => 'Troubleshooting';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmptyTitle => 'Your cart is feeling empty';

  @override
  String get proceedToCheckoutButton => 'Proceed to Checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get shippingInfoTitle => 'Delivery Address';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get shippingAddressLabel => 'Shipping Address';

  @override
  String get deliveryMethodLabel => 'Delivery Method';

  @override
  String get orderSummaryTitle => 'Order Summary';

  @override
  String get continueToPaymentButton => 'Continue to Payment';

  @override
  String checkoutDeliveryEtaFee(String eta, String fee) {
    return '$eta • $fee';
  }

  @override
  String get orderConfirmedTitle => 'Order Placed!';

  @override
  String get orderConfirmedBody =>
      'Thank you for shopping with PlantPal!\nYour goodies are on their way.';

  @override
  String get orderIdLabel => 'Order ID';

  @override
  String orderIdValue(String orderId) {
    return '#$orderId';
  }

  @override
  String get estimatedDeliveryLabel => 'Estimated Delivery';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusProcessing => 'Prepping your order';

  @override
  String get backToHomeButton => 'Back to Home';

  @override
  String get recipeTitle => 'Recipe Details';

  @override
  String get recipeNotFoundMessage => 'Recipe could not be found.';

  @override
  String get ingredientsTitle => 'Ingredients';

  @override
  String get preparationTitle => 'How to Prepare';

  @override
  String get applicationTitle => 'How to Apply';

  @override
  String get benefitsTitle => 'Key Benefits';

  @override
  String get safetyTipsTitle => 'Safety Precautions';

  @override
  String get fertilizerMakingTitle => 'Plant Food Lab';

  @override
  String get noRecipesFoundTitle => 'No recipes found';

  @override
  String noRecipesFoundBody(String query) {
    return 'No plant food recipes match \"$query\".';
  }

  @override
  String get fertilizerSearchSubtitle => 'Discover easy DIY plant nutrients';

  @override
  String nutrientLabel(String nutrient) {
    return 'Key Nutrient: $nutrient';
  }

  @override
  String get achievementsTitle => 'Badges & Milestones';

  @override
  String get noNotificationsMessage =>
      'You\'re all caught up! No new notifications.';

  @override
  String mascotThirstyMessage(String mascotName) {
    return '$mascotName is looking thirsty—time for a drink!';
  }

  @override
  String get uploadPlantPhotoPrompt => 'Snap or upload a photo';

  @override
  String get myPlantsMenuLabel => 'My Garden';

  @override
  String get aiDoctorMenuLabel => 'AI Plant Doctor';

  @override
  String get fertilizerRecipesMenuLabel => 'DIY Plant Food';

  @override
  String get maintenanceMenuLabel => 'Care Schedules';

  @override
  String get shopMenuLabel => 'Garden Shop';

  @override
  String get cameraLabel => 'Camera';

  @override
  String pointsBalanceLabel(String points, String taka) {
    return '$points pts ($taka ৳)';
  }

  @override
  String get paymentSuccessTitle => 'Payment Successful!';

  @override
  String paymentSuccessBody(String amount, String method) {
    return 'Your payment of $amount via $method was completed successfully.';
  }

  @override
  String get viewOrderButton => 'View Order Details';

  @override
  String get paymentFailedTitle => 'Payment Failed';

  @override
  String get paymentFailedBody =>
      'We couldn\'t process your payment. Please try again or use another payment option.';

  @override
  String get changePaymentMethodButton => 'Change Payment Method';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get secureCheckoutTitle => 'Encrypted Checkout';

  @override
  String get secureCheckoutBody =>
      'Your transaction details are protected with bank-grade security.';

  @override
  String get selectPaymentMethodTitle => 'Select Payment Method';

  @override
  String get orderTotalLabel => 'Order Total';

  @override
  String get processingLabel => 'Processing transaction...';

  @override
  String payButtonLabel(String amount) {
    return 'Pay $amount';
  }

  @override
  String plantAddedSnackbar(String name) {
    return '$name has joined your garden! 🌱';
  }

  @override
  String get addPlantTitle => 'Add New Plant';

  @override
  String get addPlantPhotoLabel => 'Upload Photo';

  @override
  String get nicknameLabel => 'Plant Nickname';

  @override
  String get nicknameHint => 'e.g., Leafy, Monster';

  @override
  String get plantSpeciesLabel => 'Plant Species';

  @override
  String get speciesHint => 'e.g., Monstera Deliciosa';

  @override
  String get locationHint => 'e.g., Sunroom, Bedside Table';

  @override
  String get sunlightMediumOption => 'Filtered Light';

  @override
  String get waterFrequencyLabel => 'Watering interval (days)';

  @override
  String get wateredTodayCheckbox => 'Watered today';

  @override
  String get autoFillAiScanButton => 'Identify Automatically with AI';

  @override
  String get savingLabel => 'Saving to garden...';

  @override
  String get savePlantButton => 'Save Plant';

  @override
  String get tomorrowLabel => 'Tomorrow';

  @override
  String get laterThisWeekLabel => 'Coming Up This Week';

  @override
  String get careCalendarTitle => 'Care Calendar';

  @override
  String get noCareTasksTitle => 'No upcoming care tasks';

  @override
  String get noCareTasksBody => 'Add a plant to build your watering calendar.';

  @override
  String careTaskWater(String name) {
    return 'Water $name';
  }

  @override
  String careTaskFertilize(String name) {
    return 'Feed $name';
  }

  @override
  String get allCaughtUpTitle => 'You\'re all done!';

  @override
  String get allCaughtUpBody => 'Your leafy crew is happy and hydrated.';

  @override
  String get myPlantsTitle => 'My Green Sanctuary';

  @override
  String get searchPlantsHint => 'Find a plant in your garden...';

  @override
  String get statPlants => 'Total Plants';

  @override
  String get statHealth => 'Overall Health';

  @override
  String get statWaterToday => 'Due Today';

  @override
  String get noPlantsTitle => 'Your sanctuary is empty';

  @override
  String get noPlantsBody => 'Tap + to welcome your very first plant!';

  @override
  String plantWateredSnackbar(String name) {
    return '$name is hydrated and happy! 💧';
  }

  @override
  String get deletePlantConfirmTitle => 'Remove Plant?';

  @override
  String deletePlantConfirmBody(String name) {
    return '$name will be removed from your garden collection.';
  }

  @override
  String get plantFallbackTitle => 'Plant';

  @override
  String get plantNotFoundMessage => 'We couldn\'t find that plant.';

  @override
  String get markAsWateredTooltip => 'Mark as watered';

  @override
  String get deletePlantMenuItem => 'Remove plant';

  @override
  String get todaysCareTitle => 'Today\'s Routine';

  @override
  String plantWaterLevelLabel(String level) {
    return 'Moisture Level: $level';
  }

  @override
  String get noFertilizerNoteMessage => 'No feeding schedule set yet';

  @override
  String plantFertilizeNoteLabel(String note) {
    return 'Feeding Tip: $note';
  }

  @override
  String plantLastScanLabel(String when) {
    return 'Last check-up: $when';
  }

  @override
  String get scanAgainButton => 'Scan Check-up';

  @override
  String get askAiDoctorButton => 'Consult AI Doctor';

  @override
  String get plantHistoryTitle => 'Growth Journal';

  @override
  String get noActivityTitle => 'No entries yet';

  @override
  String get noActivityBody =>
      'Scan or water a plant to kick off its growth journal!';

  @override
  String historyScanEntry(String name) {
    return '$name received an AI check-up';
  }

  @override
  String historyWateredEntry(String name) {
    return '$name was watered';
  }

  @override
  String get notScannedYetLabel => 'Awaiting first check-up';

  @override
  String healthCritical(int percent) {
    return '$percent% • Urgent Action Needed';
  }

  @override
  String healthNeedsCare(int percent) {
    return '$percent% • Attention Suggested';
  }

  @override
  String healthHealthy(int percent) {
    return '$percent% • Thriving';
  }

  @override
  String get settingsMenuLabel => 'Settings';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileMemberSince(String year) {
    return 'Plant Parent since $year';
  }

  @override
  String get statAvgHealth => 'Avg Health Score';

  @override
  String get statBadges => 'Garden Badges';

  @override
  String get quickMenuTitle => 'Quick Navigation';

  @override
  String get chooseLanguageTitle => 'Select Language';

  @override
  String get aboutBody =>
      'Version 1.0.0\n\nYour intelligent plant companion—scan, care, and cultivate your home jungle with confidence.';

  @override
  String get notificationsSectionTitle => 'Notifications';

  @override
  String get pushNotificationsLabel => 'Push Notifications';

  @override
  String get pushNotificationsSubtitle =>
      'Updates, plant tips, and announcements';

  @override
  String get wateringRemindersLabel => 'Watering Alerts';

  @override
  String get wateringRemindersSubtitle =>
      'Get notified exact moments your plants get thirsty';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get generalSectionTitle => 'General Settings';

  @override
  String get languageLabel => 'App Language';

  @override
  String get aboutPlantPalLabel => 'About PlantPal';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutConfirmBody =>
      'Are you sure you want to log out of PlantPal?';

  @override
  String get reviewsSectionTitle => 'Community Reviews';

  @override
  String get noReviewsMessage =>
      'No reviews yet. Be the first plant parent to leave a review!';

  @override
  String get writeReviewTitle => 'Write a Review';

  @override
  String get yourRatingLabel => 'Your Rating';

  @override
  String get reviewHintText => 'How did this product perform for your plants?';

  @override
  String get submitReviewButton => 'Submit Review';

  @override
  String get categoryAllLabel => 'All Items';

  @override
  String get productFallbackTitle => 'Product';

  @override
  String get productNotFoundMessage => 'Product not found.';

  @override
  String get detailsSectionTitle => 'Product Details';

  @override
  String get descriptionSectionTitle => 'Overview';

  @override
  String get quantitySectionTitle => 'Quantity';

  @override
  String productQuantityFormula(int qty, String unit) {
    return '= $qty × $unit';
  }

  @override
  String get buyNowButton => 'Buy Now';

  @override
  String productReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String productInStock(int count) {
    return '$count units left';
  }

  @override
  String get shopSubtitle => 'Curated tools and supplies for a thriving garden';

  @override
  String get searchProductsHint => 'Search products, tools, fertilizers...';

  @override
  String get noProductsFoundMessage =>
      'No products found matching your search.';

  @override
  String productAddedToCartSnackbar(String name) {
    return '$name added to your cart! 🛍️';
  }

  @override
  String get wishlistTitle => 'My Wishlist';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptyBody =>
      'Tap the heart on any product to save it for later.';

  @override
  String get browseShopButton => 'Explore the Shop';

  @override
  String get plantBotAnalyzingLabel => 'PlantBot is inspecting your leaf...';

  @override
  String get scanPlantTitle => 'Scan Your Plant';

  @override
  String get analyzingPlantLabel => 'Analyzing leaf patterns & health...';

  @override
  String get chooseFromGalleryButton => 'Choose from Photo Gallery';

  @override
  String get plantIdentifiedTitle => 'Match Found!';

  @override
  String get noScanYetTitle => 'No active scan';

  @override
  String get noScanYetBody =>
      'Take or select a photo of your plant to analyze.';

  @override
  String get unknownPlantLabel => 'Unrecognized Species';

  @override
  String get aiHardcodedLabel => 'Sample Result';

  @override
  String get viewCareGuideButton => 'Open Care Guide';

  @override
  String get captionHint => 'Add a note or caption (optional)...';

  @override
  String get chatInputHint => 'Ask your plant question...';

  @override
  String get aiVisionAnalysisTitle => 'AI Vision Diagnostics';

  @override
  String diagnosisProblemLabel(String issue) {
    return 'Detected Concern: $issue';
  }

  @override
  String diagnosisConfidenceSeverity(String confidence, String severity) {
    return 'Confidence: $confidence | Severity: $severity';
  }

  @override
  String get treatmentLabel => 'Treatment:';

  @override
  String get recommendedFertilizerLabel => 'Recommended Fertilizer:';

  @override
  String get shopProductsLabel => 'Shop Products:';

  @override
  String bulletItem(String item) {
    return '• $item';
  }

  @override
  String get aiDisclaimerText =>
      'AI guidance only — not a guaranteed diagnosis. Check with a local plant expert for serious issues.';

  @override
  String get chatWelcomeMessage =>
      'Hello! I\'m PlantBot.\nHow can I help your plants today?';

  @override
  String get chatSuggestion1 => 'Why are my leaves yellow?';

  @override
  String get chatSuggestion2 => 'Homemade Banana Fertilizer';

  @override
  String get chatSuggestion3 => 'Treat Leaf Spot';

  @override
  String get chatRateLimitError =>
      'Free-tier rate limit reached. Please wait 10 seconds and try again.';

  @override
  String get signInRequiredChatMessage =>
      'Please sign in with Google to chat with PlantBot.';

  @override
  String get connectionErrorMessage =>
      'I am having trouble connecting to my plant knowledge base. Please check your connection.';

  @override
  String get genericChatErrorMessage =>
      'I had trouble with that request. Please try again!';

  @override
  String get scanRateLimitError =>
      'Rate limit reached. Please wait 10 seconds and try again.';

  @override
  String get signInRequiredScanMessage =>
      'Please sign in with Google to scan plants.';

  @override
  String get scanAnalysisErrorMessage =>
      'I couldn\'t analyze that photo. Please try again.';

  @override
  String get plantDetailsTitle => 'Plant Details';

  @override
  String get careSummaryTitle => 'Care Summary';

  @override
  String get actionsTitle => 'Actions';

  @override
  String get lastWateredLabel => 'Last Watered';

  @override
  String get nextWaterLabel => 'Next Watering';

  @override
  String get sunlightLabel => 'Sunlight';

  @override
  String get neverWateredLabel => 'Never';

  @override
  String get wateredTodayLabel => 'Today';

  @override
  String daysAgoLabel(int days) {
    return '${days}d ago';
  }

  @override
  String get waterNowLabel => 'Water now!';

  @override
  String daysLeftLabel(int days) {
    return 'In ${days}d';
  }

  @override
  String get unknownSpeciesLabel => 'Unknown species';

  @override
  String get noNicknameLabel => 'No nickname';

  @override
  String get markWateredButton => 'Mark as Watered';

  @override
  String get editPlantButton => 'Edit Plant';

  @override
  String markedWateredSnackbar(String name) {
    return '$name has been watered 💧';
  }

  @override
  String get needsWaterTooltip => 'Needs water';

  @override
  String get emptyPlantsTitle => 'No plants yet';

  @override
  String get emptyPlantsBody => 'Tap + to add your first plant.';

  @override
  String get addFirstPlantButton => 'Add your first plant';

  @override
  String get plantsGridHeader => 'My Plants';

  @override
  String get editPlantTitle => 'Edit Plant';

  @override
  String get plantSavedSnackbar => 'Plant saved successfully.';

  @override
  String get deleteConfirmTitle => 'Delete this plant?';

  @override
  String get deleteConfirmBody => 'This action cannot be undone.';

  @override
  String get deletePlantButton => 'Delete Plant';

  @override
  String get changePhotoLabel => 'Change Photo';

  @override
  String get settingsSectionTitle => 'Settings';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get helpLabel => 'Help';

  @override
  String get aboutLabel => 'About';

  @override
  String get profileStatPlants => 'Plants';

  @override
  String get profileStatOrders => 'Orders';

  @override
  String get profileStatPoints => 'Points';

  @override
  String get shopTitle => 'Shop';

  @override
  String get allCategoryLabel => 'All';

  @override
  String get noProductsFoundTitle => 'No products found';

  @override
  String get noScanResultTitle => 'No scan yet';

  @override
  String get noScanResultBody => 'Take or choose a plant photo first.';

  @override
  String get defaultDisplayName => 'Plant Parent';

  @override
  String get refreshPriceButton => 'Refresh Price via AI';

  @override
  String get checkingPriceLabel => 'Checking live price...';

  @override
  String get aiPriceRefreshedLabel => 'AI Price Check';

  @override
  String priceCheckedAgoLabel(String timeAgo) {
    return 'Checked $timeAgo';
  }

  @override
  String get possiblyOutOfStockLabel => 'May be out of stock';

  @override
  String get priceRefreshFailedLabel => 'Couldn\'t fetch live price';

  @override
  String get refreshAgainLabel => 'Refresh again';

  @override
  String get retryLabel => 'Retry';

  @override
  String get justNowLabel => 'just now';

  @override
  String minutesAgoLabel(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgoLabel(int count) {
    return '${count}h ago';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navScan => 'Scan';

  @override
  String get navShop => 'Shop';

  @override
  String get navAiDoctor => 'AI Doctor';

  @override
  String get navProfile => 'Profile';

  @override
  String get myOrdersLabel => 'My Orders';

  @override
  String get noOrdersTitle => 'No orders yet';

  @override
  String get noOrdersBody => 'Orders you place will show up here.';

  @override
  String get markAsFertilizedTooltip => 'Mark as fertilized';

  @override
  String plantFertilizedSnackbar(String name) {
    return '$name has been fed!';
  }
}
