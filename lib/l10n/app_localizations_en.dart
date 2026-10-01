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
  String get splashTagline => 'Grow with confidence';

  @override
  String get homeHeaderTitle => 'Let\'s care for\nyour plants';

  @override
  String get homeHeaderSubtitle => 'Diagnose, feed, and grow with confidence.';

  @override
  String get greetingMorning =>
      'Good morning! ╬ô├┐├çΓê⌐Γòò├à Ready to check on your plants?';

  @override
  String get greetingAfternoon =>
      'Good afternoon! Γëí╞Æ├«├▒Γê⌐Γòò├à How are your plants doing?';

  @override
  String get greetingEvening =>
      'Good evening! Γëí╞Æ├«├Ñ Time for one last check-in.';

  @override
  String get greetingNight =>
      'Still up? Γëí╞Æ├«├û Your plants are resting too.';

  @override
  String get greetingPlantThirsty =>
      'Γëí╞Æ├«ΓûÆ One of your plants is thirsty today!';

  @override
  String get greetingWeatherRain =>
      'It\'s rainy out there Γëí╞Æ├«┬║Γê⌐Γòò├à ╬ô├ç├╢ skip watering outdoor plants today.';

  @override
  String get greetingWeatherThunderstorm =>
      'Storms nearby ╬ô┬ó├¬Γê⌐Γòò├à ╬ô├ç├╢ keep sensitive plants indoors.';

  @override
  String get greetingWeatherSnow =>
      'It\'s snowing ╬ô┬Ñ├ñΓê⌐Γòò├à ╬ô├ç├╢ bring tender plants inside.';

  @override
  String get greetingWeatherFog =>
      'Foggy morning Γëí╞Æ├«┬╜Γê⌐Γòò├à ╬ô├ç├╢ your plants love the extra humidity.';

  @override
  String greetingWeatherHot(int temperature) {
    return 'It\'s $temperatureΓö¼ΓûæC out Γëí╞Æ├╢├æ ╬ô├ç├╢ your plants may need extra water.';
  }

  @override
  String get uploadPlantPhoto => 'Upload your Plant\'s Photo';

  @override
  String get quickActionsLabel => 'QUICK ACTIONS';

  @override
  String get myPlantsLabel => 'My Plants';

  @override
  String get maintainance => 'Maintainance';

  @override
  String get diseaseDetectionTile => 'Disease Detection';

  @override
  String get fertilizerRecipesLabel => 'Fertilizer Recipes';

  @override
  String get shopLabel => 'Shop';

  @override
  String get chatWithExpertLabel => 'Chat with expert';

  @override
  String get mainMenuButton => 'MainMenu';

  @override
  String get fertilizerHeaderTitle => 'Fertilizer Making';

  @override
  String get fertilizerHeaderSubtitle =>
      'Homemade recipes for every growth stage.';

  @override
  String get addFertilizerButton => 'Add a new Fertilizer';

  @override
  String get fertilizerNameFieldLabel => 'Name';

  @override
  String get fertilizerCategoryFieldLabel => 'Category';

  @override
  String get fertilizerInstructionsFieldLabel => 'Instructions';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get searchFertilizerHint => 'Find your homemade fertilizer';

  @override
  String get noFertilizersFound => 'No fertilizers found.';

  @override
  String get serverUnreachable =>
      'Could not reach the server. Is the backend running?';

  @override
  String get maintainanceHeaderSubtitleForm =>
      'Tell us about your plant to get a care plan.';

  @override
  String get maintainanceHeaderSubtitleResult =>
      'Here╬ô├ç├ûs the care plan for your plant.';

  @override
  String get nameOfPlantLabel => 'Name of the Plant';

  @override
  String get nameFieldHint => 'Value';

  @override
  String get typesOfPlantLabel => 'Types of Plant';

  @override
  String get typesFieldHint => 'Water based, Maniplant etc';

  @override
  String get plantAgeLabel => 'How are the plant\'s age ?';

  @override
  String get ageFieldHint => 'Seed, Seedlings...';

  @override
  String get createRoadmapButton => 'Create My Roadmap';

  @override
  String yourPlantNeeds(String plantName, int amount) {
    return 'Your plant \'$plantName\' needs around $amount ml water daily. Here is the time table you can water your plants';
  }

  @override
  String get setAlarmButton => 'Set Alarm';

  @override
  String tipsLabel(String tips) {
    return 'Tips: $tips';
  }

  @override
  String weatherTipHot(int waterMl) {
    return 'It\'s too hot today Γëí╞Æ├╢├æ ╬ô├ç├╢ give at least $waterMl ml water today.';
  }

  @override
  String get weatherTipCold =>
      'It\'s cold today ╬ô┬Ñ├ñΓê⌐Γòò├à ╬ô├ç├╢ water a little less to avoid root rot.';

  @override
  String get weatherTipWetOutside =>
      'It\'s wet outside today Γëí╞Æ├«┬║Γê⌐Γòò├à ╬ô├ç├╢ skip watering outdoor plants.';

  @override
  String get diseasesDetectionHeader => 'Diseases\nDetection';

  @override
  String get diseasesDetectionSubtitle =>
      'Snap a photo and get an instant assessment.';

  @override
  String get openCameraButton => 'Open Camera to take photo';

  @override
  String cureLabel(String cure) {
    return 'Cure: $cure';
  }

  @override
  String get addToLogButton => 'Add to Log';

  @override
  String get buyFertilizerButton => 'Buy Fertilizer';

  @override
  String get appTagline => 'Your Garden\'s best Friend';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get deleteButton => 'Delete';

  @override
  String get backButton => 'Back';

  @override
  String get closeButton => 'Close';

  @override
  String get continueShoppingButton => 'Continue Shopping';

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
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get locationLabel => 'Location';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get loginWelcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Missing your buddies?';

  @override
  String get loginButton => 'Login';

  @override
  String get orDivider => 'OR';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get registerLink => 'Register';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get emailSignInUnavailable =>
      'Email sign-in isn\'t available yet. Please continue with Google.';

  @override
  String get signingInLabel => 'Signing in...';

  @override
  String get continueWithGoogleButton => 'Continue with Google';

  @override
  String get continueAsGuestButton => 'Continue as guest (debug only)';

  @override
  String get careMetricWater => 'Water';

  @override
  String get careMetricSunlight => 'Sunlight';

  @override
  String get careMetricTemp => 'Temp';

  @override
  String get careMetricFertilizer => 'Fertilizer';

  @override
  String get careMetricHumidity => 'Humidity';

  @override
  String get careGuideTitle => 'Care Guide';

  @override
  String get careChallengeTitle => 'Today\'s Care Challenge';

  @override
  String get careChallengeDoneMessage =>
      'All done! Your plant is thriving today.';

  @override
  String get careEssentialsTitle => 'Essentials';

  @override
  String get careProTipsTitle => 'Pro Tips';

  @override
  String get careCommonProblemsTitle => 'Common Problems';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get proceedToCheckoutButton => 'Proceed to Checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get shippingInfoTitle => 'Shipping Information';

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
    return '$eta ╬ô├ç├│ $fee';
  }

  @override
  String get orderConfirmedTitle => 'Order Confirmed!';

  @override
  String get orderConfirmedBody =>
      'Thank you for shopping with PlantPal.\nYour order has been placed successfully.';

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
  String get statusProcessing => 'Processing';

  @override
  String get backToHomeButton => 'Back to Home';

  @override
  String get recipeTitle => 'Recipe';

  @override
  String get recipeNotFoundMessage => 'Recipe not found.';

  @override
  String get ingredientsTitle => 'Ingredients';

  @override
  String get preparationTitle => 'Preparation';

  @override
  String get applicationTitle => 'Application';

  @override
  String get benefitsTitle => 'Benefits';

  @override
  String get safetyTipsTitle => 'Safety Tips';

  @override
  String get fertilizerMakingTitle => 'Fertilizer Making';

  @override
  String get noRecipesFoundTitle => 'No recipes found';

  @override
  String noRecipesFoundBody(String query) {
    return 'Nothing matches \"$query\".';
  }

  @override
  String get fertilizerSearchSubtitle => 'Find your homemade fertilizer';

  @override
  String nutrientLabel(String nutrient) {
    return 'Nutrient: $nutrient';
  }

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get noNotificationsMessage => 'No new notifications.';

  @override
  String mascotThirstyMessage(String mascotName) {
    return '$mascotName is thirsty, give him some water';
  }

  @override
  String get uploadPlantPhotoPrompt => 'Upload your Plant\'s Photo';

  @override
  String get myPlantsMenuLabel => 'My Plants';

  @override
  String get aiDoctorMenuLabel => 'AI Doctor';

  @override
  String get fertilizerRecipesMenuLabel => 'Fertilizer Recipes';

  @override
  String get maintenanceMenuLabel => 'Maintenance';

  @override
  String get shopMenuLabel => 'Shop';

  @override
  String get cameraLabel => 'Camera';

  @override
  String pointsBalanceLabel(String points, String taka) {
    return '$points points ( $taka taka)';
  }

  @override
  String get paymentSuccessTitle => 'Payment Successful!';

  @override
  String paymentSuccessBody(String amount, String method) {
    return 'Your payment of $amount via $method was completed. Your order has been placed.';
  }

  @override
  String get viewOrderButton => 'View Order';

  @override
  String get paymentFailedTitle => 'Payment Failed';

  @override
  String get paymentFailedBody =>
      'We could not process your payment. Please try again or choose a different payment method.';

  @override
  String get changePaymentMethodButton => 'Change Payment Method';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get secureCheckoutTitle => 'Secure Checkout';

  @override
  String get secureCheckoutBody =>
      'Your payment information is encrypted and secure.';

  @override
  String get selectPaymentMethodTitle => 'Select Payment Method';

  @override
  String get orderTotalLabel => 'Order Total';

  @override
  String get processingLabel => 'Processing...';

  @override
  String payButtonLabel(String amount) {
    return 'Pay $amount';
  }

  @override
  String plantAddedSnackbar(String name) {
    return '$name has been added Γëí╞Æ├«ΓûÆ';
  }

  @override
  String get addPlantTitle => 'Add Plant';

  @override
  String get addPlantPhotoLabel => 'Add Plant Photo';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHint => 'Bella';

  @override
  String get plantSpeciesLabel => 'Plant Species';

  @override
  String get speciesHint => 'Monstera Deliciosa';

  @override
  String get locationHint => 'Living Room';

  @override
  String get sunlightMediumOption => 'Medium';

  @override
  String get waterFrequencyLabel => 'Water every (days)';

  @override
  String get wateredTodayCheckbox => 'I watered it today';

  @override
  String get autoFillAiScanButton => 'Auto Fill Using AI Scan';

  @override
  String get savingLabel => 'Saving...';

  @override
  String get savePlantButton => 'Save Plant';

  @override
  String get tomorrowLabel => 'Tomorrow';

  @override
  String get laterThisWeekLabel => 'Later This Week';

  @override
  String get careCalendarTitle => 'Care Calendar';

  @override
  String get noCareTasksTitle => 'No care tasks yet';

  @override
  String get noCareTasksBody => 'Add a plant to see its watering schedule.';

  @override
  String careTaskWater(String name) {
    return 'Water $name';
  }

  @override
  String careTaskFertilize(String name) {
    return 'Fertilize $name';
  }

  @override
  String get allCaughtUpTitle => 'All caught up!';

  @override
  String get allCaughtUpBody => 'Your plants thank you.';

  @override
  String get myPlantsTitle => 'My Green Family';

  @override
  String get searchPlantsHint => 'Search plants...';

  @override
  String get statPlants => 'Plants';

  @override
  String get statHealth => 'Health';

  @override
  String get statWaterToday => 'Water Today';

  @override
  String get noPlantsTitle => 'No plants yet';

  @override
  String get noPlantsBody => 'Tap + to add your first plant.';

  @override
  String plantWateredSnackbar(String name) {
    return '$name marked as watered Γëí╞Æ├å┬║';
  }

  @override
  String get deletePlantConfirmTitle => 'Delete plant?';

  @override
  String deletePlantConfirmBody(String name) {
    return '$name will be removed from your collection.';
  }

  @override
  String get plantFallbackTitle => 'Plant';

  @override
  String get plantNotFoundMessage => 'Plant not found.';

  @override
  String get markAsWateredTooltip => 'Mark as watered';

  @override
  String get deletePlantMenuItem => 'Delete plant';

  @override
  String get todaysCareTitle => 'Today\'s Care';

  @override
  String plantWaterLevelLabel(String level) {
    return 'Water: $level';
  }

  @override
  String get noFertilizerNoteMessage => 'No fertilizer note yet';

  @override
  String plantFertilizeNoteLabel(String note) {
    return 'Fertilize: $note';
  }

  @override
  String plantLastScanLabel(String when) {
    return 'Last scan: $when';
  }

  @override
  String get scanAgainButton => 'Scan Again';

  @override
  String get askAiDoctorButton => 'Ask AI Doctor';

  @override
  String get plantHistoryTitle => 'Plant History';

  @override
  String get noActivityTitle => 'No activity yet';

  @override
  String get noActivityBody => 'Scan or water a plant to get started!';

  @override
  String historyScanEntry(String name) {
    return '$name was scanned';
  }

  @override
  String historyWateredEntry(String name) {
    return '$name was watered';
  }

  @override
  String get notScannedYetLabel => 'Not scanned yet';

  @override
  String healthCritical(int percent) {
    return '$percent% ╬ô├ç├│ Critical';
  }

  @override
  String healthNeedsCare(int percent) {
    return '$percent% ╬ô├ç├│ Needs Care';
  }

  @override
  String healthHealthy(int percent) {
    return '$percent% ╬ô├ç├│ Healthy';
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
  String get statAvgHealth => 'Avg Health';

  @override
  String get statBadges => 'Badges';

  @override
  String get quickMenuTitle => 'Quick Menu';

  @override
  String get chooseLanguageTitle => 'Choose Language';

  @override
  String get aboutBody =>
      'Version 1.0.0\n\nYour friendly AI gardening assistant ╬ô├ç├╢ scan, track, and care for your plants with confidence.';

  @override
  String get notificationsSectionTitle => 'Notifications';

  @override
  String get pushNotificationsLabel => 'Push Notifications';

  @override
  String get pushNotificationsSubtitle => 'General app updates and alerts';

  @override
  String get wateringRemindersLabel => 'Watering Reminders';

  @override
  String get wateringRemindersSubtitle =>
      'Get notified when a plant needs water';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get generalSectionTitle => 'General';

  @override
  String get languageLabel => 'Language';

  @override
  String get aboutPlantPalLabel => 'About PlantPal';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutConfirmBody => 'Are you sure you want to log out?';

  @override
  String get reviewsSectionTitle => 'Reviews';

  @override
  String get noReviewsMessage =>
      'No reviews yet. Be the first to share your experience!';

  @override
  String get writeReviewTitle => 'Write a Review';

  @override
  String get yourRatingLabel => 'Your rating';

  @override
  String get reviewHintText => 'Share your experience with this product...';

  @override
  String get submitReviewButton => 'Submit Review';

  @override
  String get categoryAllLabel => 'All';

  @override
  String get productFallbackTitle => 'Product';

  @override
  String get productNotFoundMessage => 'Product not found.';

  @override
  String get detailsSectionTitle => 'Details';

  @override
  String get descriptionSectionTitle => 'Description';

  @override
  String get quantitySectionTitle => 'Quantity';

  @override
  String productQuantityFormula(int qty, String unit) {
    return '= $qty Γö£├╣ $unit';
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
    return '$count in stock';
  }

  @override
  String get shopSubtitle => 'Find your necessary gardening equipment';

  @override
  String get searchProductsHint => 'Search products...';

  @override
  String get noProductsFoundMessage => 'No products found';

  @override
  String productAddedToCartSnackbar(String name) {
    return '$name added to cart';
  }

  @override
  String get wishlistTitle => 'My Wishlist';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptyBody =>
      'Tap the heart on any product to save it here.';

  @override
  String get browseShopButton => 'Browse Shop';

  @override
  String get plantBotAnalyzingLabel => 'PlantBot is analyzing...';

  @override
  String get scanPlantTitle => 'Scan Your Plant';

  @override
  String get analyzingPlantLabel => 'Analyzing your plant...';

  @override
  String get chooseFromGalleryButton => 'Choose from Gallery';

  @override
  String get plantIdentifiedTitle => 'Plant Identified';

  @override
  String get noScanYetTitle => 'No scan yet';

  @override
  String get noScanYetBody => 'Take or choose a plant photo first.';

  @override
  String get unknownPlantLabel => 'Unknown plant';

  @override
  String get aiHardcodedLabel => 'Hardcoded';

  @override
  String get viewCareGuideButton => 'View Care Guide';

  @override
  String get captionHint => 'Add a caption (optional)...';

  @override
  String get chatInputHint => 'Ask anything...';

  @override
  String get aiVisionAnalysisTitle => 'AI Vision Analysis';

  @override
  String diagnosisProblemLabel(String issue) {
    return 'Problem: $issue';
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
    return '╬ô├ç├│ $item';
  }

  @override
  String get aiDisclaimerText =>
      'AI guidance only ╬ô├ç├╢ not a guaranteed diagnosis. Check with a local plant expert for serious issues.';

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
    return '$name has been watered ≡ƒÆº';
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
}
