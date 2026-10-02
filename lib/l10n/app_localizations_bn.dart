// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'MyPlantPal';

  @override
  String get splashTagline => 'আত্মবিশ্বাসের সাথে বেড়ে উঠুন';

  @override
  String get homeHeaderTitle => 'আসুন যত্ন নেই\nআপনার গাছের';

  @override
  String get homeHeaderSubtitle =>
      'রোগ নির্ণয়, পুষ্টি জোগান, আত্মবিশ্বাসের সাথে বাড়ান।';

  @override
  String get greetingMorning => 'শুভ সকাল!  আপনার গাছগুলো দেখে নিন?';

  @override
  String get greetingAfternoon => 'শুভ অপরাহ্ন!  আপনার গাছগুলো কেমন আছে?';

  @override
  String get greetingEvening => 'শুভ সন্ধ্যা!  শেষবারের মতো একবার দেখে নিন।';

  @override
  String get greetingNight => 'এখনও জেগে আছেন? আপনার গাছগুলোও বিশ্রাম নিচ্ছে।';

  @override
  String get greetingPlantThirsty => ' আপনার একটি গাছের আজ পানি দরকার!';

  @override
  String get greetingWeatherRain =>
      'বাইরে বৃষ্টি হচ্ছে  — আজ বাইরের গাছে পানি দেওয়ার দরকার নেই।';

  @override
  String get greetingWeatherThunderstorm =>
      'কাছাকাছি ঝড় হচ্ছে  — সংবেদনশীল গাছগুলো ঘরে রাখুন।';

  @override
  String get greetingWeatherSnow =>
      'তুষারপাত হচ্ছে  — নরম গাছগুলো ঘরে নিয়ে আসুন।';

  @override
  String get greetingWeatherFog =>
      'কুয়াশাচ্ছন্ন সকাল  — আপনার গাছগুলো এই বাড়তি আর্দ্রতা পছন্দ করে।';

  @override
  String greetingWeatherHot(int temperature) {
    return 'বাইরে $temperature°সে তাপমাত্রা  — আপনার গাছের বাড়তি পানি লাগতে পারে।';
  }

  @override
  String get uploadPlantPhoto => 'আপনার গাছের ছবি আপলোড করুন';

  @override
  String get quickActionsLabel => 'দ্রুত কার্যক্রম';

  @override
  String get myPlantsLabel => 'আমার গাছপালা';

  @override
  String get maintainance => 'রক্ষণাবেক্ষণ';

  @override
  String get diseaseDetectionTile => 'রোগ শনাক্তকরণ';

  @override
  String get fertilizerRecipesLabel => 'সার তৈরির রেসিপি';

  @override
  String get shopLabel => 'দোকান';

  @override
  String get chatWithExpertLabel => 'বিশেষজ্ঞের সাথে চ্যাট করুন';

  @override
  String get mainMenuButton => 'প্রধান মেনু';

  @override
  String get fertilizerHeaderTitle => 'সার তৈরি';

  @override
  String get fertilizerHeaderSubtitle =>
      'প্রতিটি বৃদ্ধির ধাপের জন্য ঘরে তৈরি রেসিপি।';

  @override
  String get addFertilizerButton => 'নতুন সার যোগ করুন';

  @override
  String get fertilizerNameFieldLabel => 'নাম';

  @override
  String get fertilizerCategoryFieldLabel => 'বিভাগ';

  @override
  String get fertilizerInstructionsFieldLabel => 'নির্দেশাবলী';

  @override
  String get cancelButton => 'বাতিল';

  @override
  String get saveButton => 'সংরক্ষণ করুন';

  @override
  String get searchFertilizerHint => 'আপনার ঘরে তৈরি সার খুঁজুন';

  @override
  String get noFertilizersFound => 'কোনো সার পাওয়া যায়নি।';

  @override
  String get serverUnreachable => 'সার্ভারে পৌঁছানো যায়নি। ব্যাকএন্ড কি চলছে?';

  @override
  String get maintainanceHeaderSubtitleForm =>
      'যত্নের পরিকল্পনা পেতে আপনার গাছ সম্পর্কে জানান।';

  @override
  String get maintainanceHeaderSubtitleResult =>
      'এই দেখুন আপনার গাছের যত্নের পরিকল্পনা।';

  @override
  String get nameOfPlantLabel => 'গাছের নাম';

  @override
  String get nameFieldHint => 'মান লিখুন';

  @override
  String get typesOfPlantLabel => 'গাছের ধরন';

  @override
  String get typesFieldHint => 'জল ভিত্তিক, মানিপ্ল্যান্ট ইত্যাদি';

  @override
  String get plantAgeLabel => 'গাছের বয়স কেমন?';

  @override
  String get ageFieldHint => 'বীজ, চারা...';

  @override
  String get createRoadmapButton => 'আমার পরিকল্পনা তৈরি করুন';

  @override
  String yourPlantNeeds(String plantName, int amount) {
    return 'আপনার \'$plantName\' গাছের প্রতিদিন প্রায় $amount মিলি পানি প্রয়োজন। এখানে পানি দেওয়ার সময়সূচী দেওয়া হলো';
  }

  @override
  String get setAlarmButton => 'অ্যালার্ম সেট করুন';

  @override
  String tipsLabel(String tips) {
    return 'পরামর্শ: $tips';
  }

  @override
  String weatherTipHot(int waterMl) {
    return 'আজ খুব গরম  — আজ অন্তত $waterMl মিলি পানি দিন।';
  }

  @override
  String get weatherTipCold => 'আজ ঠান্ডা - মূল পচন এড়াতে একটু কম পানি দিন।';

  @override
  String get weatherTipWetOutside =>
      'আজ বাইরে ভেজা আবহাওয়া - বাইরের গাছে পানি দেওয়ার দরকার নেই।';

  @override
  String get diseasesDetectionHeader => 'রোগ\nশনাক্তকরণ';

  @override
  String get diseasesDetectionSubtitle =>
      'একটি ছবি তুলুন এবং তাৎক্ষণিক মূল্যায়ন পান।';

  @override
  String get openCameraButton => 'ছবি তুলতে ক্যামেরা খুলুন';

  @override
  String cureLabel(String cure) {
    return 'প্রতিকার: $cure';
  }

  @override
  String get addToLogButton => 'লগে যোগ করুন';

  @override
  String get buyFertilizerButton => 'সার কিনুন';

  @override
  String get appTagline => 'আপনার বাগানের সেরা বন্ধু';

  @override
  String get getStartedButton => 'শুরু করুন';

  @override
  String get deleteButton => 'মুছুন';

  @override
  String get backButton => 'পেছনে';

  @override
  String get closeButton => 'বন্ধ করুন';

  @override
  String get continueShoppingButton => 'কেনাকাটা চালিয়ে যান';

  @override
  String get addToCartButton => 'কার্টে যোগ করুন';

  @override
  String get logOutButton => 'লগ আউট';

  @override
  String get todayLabel => 'আজ';

  @override
  String get onLabel => 'চালু';

  @override
  String get offLabel => 'বন্ধ';

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get fullNameLabel => 'পূর্ণ নাম';

  @override
  String get locationLabel => 'অবস্থান';

  @override
  String get loadingLabel => 'লোড হচ্ছে...';

  @override
  String get loginWelcomeBack => 'আবার স্বাগতম!';

  @override
  String get loginSubtitle => 'আপনার গাছেদের মিস করছেন?';

  @override
  String get loginButton => 'লগইন';

  @override
  String get orDivider => 'অথবা';

  @override
  String get noAccountPrompt => 'অ্যাকাউন্ট নেই?';

  @override
  String get registerLink => 'নিবন্ধন করুন';

  @override
  String get createAccountButton => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get emailSignInUnavailable =>
      'ইমেইল দিয়ে সাইন-ইন এখনো চালু হয়নি। অনুগ্রহ করে Google দিয়ে চালিয়ে যান।';

  @override
  String get signingInLabel => 'সাইন ইন হচ্ছে...';

  @override
  String get continueWithGoogleButton => 'Google দিয়ে চালিয়ে যান';

  @override
  String get continueAsGuestButton => 'গেস্ট হিসেবে চালিয়ে যান (শুধু ডিবাগ)';

  @override
  String get careMetricWater => 'পানি';

  @override
  String get careMetricSunlight => 'রোদ';

  @override
  String get careMetricTemp => 'তাপমাত্রা';

  @override
  String get careMetricFertilizer => 'সার';

  @override
  String get careMetricHumidity => 'আর্দ্রতা';

  @override
  String get careGuideTitle => 'পরিচর্যা গাইড';

  @override
  String get careChallengeTitle => 'আজকের পরিচর্যা চ্যালেঞ্জ';

  @override
  String get careChallengeDoneMessage =>
      'সব শেষ! আপনার গাছ আজ দারুণ অবস্থায় আছে।';

  @override
  String get careEssentialsTitle => 'মূল বিষয়';

  @override
  String get careProTipsTitle => 'বিশেষজ্ঞ টিপস';

  @override
  String get careCommonProblemsTitle => 'সাধারণ সমস্যা';

  @override
  String get cartTitle => 'আমার কার্ট';

  @override
  String get cartEmptyTitle => 'আপনার কার্ট খালি';

  @override
  String get proceedToCheckoutButton => 'চেকআউটে যান';

  @override
  String get checkoutTitle => 'চেকআউট';

  @override
  String get shippingInfoTitle => 'শিপিং তথ্য';

  @override
  String get phoneNumberLabel => 'ফোন নম্বর';

  @override
  String get shippingAddressLabel => 'শিপিং ঠিকানা';

  @override
  String get deliveryMethodLabel => 'ডেলিভারি পদ্ধতি';

  @override
  String get orderSummaryTitle => 'অর্ডার সারাংশ';

  @override
  String get continueToPaymentButton => 'পেমেন্টে যান';

  @override
  String checkoutDeliveryEtaFee(String eta, String fee) {
    return '$eta • $fee';
  }

  @override
  String get orderConfirmedTitle => 'অর্ডার নিশ্চিত হয়েছে!';

  @override
  String get orderConfirmedBody =>
      'PlantPal-এ কেনাকাটার জন্য ধন্যবাদ।\nআপনার অর্ডারটি সফলভাবে দেওয়া হয়েছে।';

  @override
  String get orderIdLabel => 'অর্ডার আইডি';

  @override
  String orderIdValue(String orderId) {
    return '#$orderId';
  }

  @override
  String get estimatedDeliveryLabel => 'আনুমানিক ডেলিভারি';

  @override
  String get statusLabel => 'অবস্থা';

  @override
  String get statusProcessing => 'প্রসেস হচ্ছে';

  @override
  String get backToHomeButton => 'হোমে ফিরুন';

  @override
  String get recipeTitle => 'রেসিপি';

  @override
  String get recipeNotFoundMessage => 'রেসিপি পাওয়া যায়নি।';

  @override
  String get ingredientsTitle => 'উপকরণ';

  @override
  String get preparationTitle => 'প্রস্তুত প্রণালী';

  @override
  String get applicationTitle => 'প্রয়োগ';

  @override
  String get benefitsTitle => 'উপকারিতা';

  @override
  String get safetyTipsTitle => 'সতর্কতা';

  @override
  String get fertilizerMakingTitle => 'সার তৈরি';

  @override
  String get noRecipesFoundTitle => 'কোনো রেসিপি পাওয়া যায়নি';

  @override
  String noRecipesFoundBody(String query) {
    return '\"$query\" এর সাথে কিছু মেলেনি।';
  }

  @override
  String get fertilizerSearchSubtitle => 'আপনার ঘরে তৈরি সার খুঁজুন';

  @override
  String nutrientLabel(String nutrient) {
    return 'পুষ্টি উপাদান: $nutrient';
  }

  @override
  String get achievementsTitle => 'অর্জন';

  @override
  String get noNotificationsMessage => 'নতুন কোনো নোটিফিকেশন নেই।';

  @override
  String mascotThirstyMessage(String mascotName) {
    return '$mascotName তৃষ্ণার্ত, একটু পানি দিন';
  }

  @override
  String get uploadPlantPhotoPrompt => 'আপনার গাছের ছবি আপলোড করুন';

  @override
  String get myPlantsMenuLabel => 'আমার গাছ';

  @override
  String get aiDoctorMenuLabel => 'AI ডাক্তার';

  @override
  String get fertilizerRecipesMenuLabel => 'সারের রেসিপি';

  @override
  String get maintenanceMenuLabel => 'রক্ষণাবেক্ষণ';

  @override
  String get shopMenuLabel => 'দোকান';

  @override
  String get cameraLabel => 'ক্যামেরা';

  @override
  String pointsBalanceLabel(String points, String taka) {
    return '$points পয়েন্ট ( $taka টাকা)';
  }

  @override
  String get paymentSuccessTitle => 'পেমেন্ট সফল হয়েছে!';

  @override
  String paymentSuccessBody(String amount, String method) {
    return '$method-এর মাধ্যমে $amount পেমেন্ট সম্পন্ন হয়েছে। আপনার অর্ডার দেওয়া হয়েছে।';
  }

  @override
  String get viewOrderButton => 'অর্ডার দেখুন';

  @override
  String get paymentFailedTitle => 'পেমেন্ট ব্যর্থ হয়েছে';

  @override
  String get paymentFailedBody =>
      'আমরা আপনার পেমেন্ট প্রসেস করতে পারিনি। অনুগ্রহ করে আবার চেষ্টা করুন অথবা অন্য পেমেন্ট পদ্ধতি বেছে নিন।';

  @override
  String get changePaymentMethodButton => 'পেমেন্ট পদ্ধতি পরিবর্তন করুন';

  @override
  String get tryAgainButton => 'আবার চেষ্টা করুন';

  @override
  String get paymentTitle => 'পেমেন্ট';

  @override
  String get secureCheckoutTitle => 'নিরাপদ চেকআউট';

  @override
  String get secureCheckoutBody => 'আপনার পেমেন্ট তথ্য এনক্রিপ্ট করা ও নিরাপদ।';

  @override
  String get selectPaymentMethodTitle => 'পেমেন্ট পদ্ধতি বেছে নিন';

  @override
  String get orderTotalLabel => 'মোট মূল্য';

  @override
  String get processingLabel => 'প্রসেস হচ্ছে...';

  @override
  String payButtonLabel(String amount) {
    return '$amount পরিশোধ করুন';
  }

  @override
  String plantAddedSnackbar(String name) {
    return '$name যোগ করা হয়েছে ';
  }

  @override
  String get addPlantTitle => 'গাছ যোগ করুন';

  @override
  String get addPlantPhotoLabel => 'গাছের ছবি যোগ করুন';

  @override
  String get nicknameLabel => 'ডাকনাম';

  @override
  String get nicknameHint => 'বেলা';

  @override
  String get plantSpeciesLabel => 'গাছের প্রজাতি';

  @override
  String get speciesHint => 'মনস্টেরা ডেলিসিওসা';

  @override
  String get locationHint => 'লিভিং রুম';

  @override
  String get sunlightMediumOption => 'মাঝারি';

  @override
  String get waterFrequencyLabel => 'কত দিন পরপর পানি দিতে হবে';

  @override
  String get wateredTodayCheckbox => 'আজ পানি দিয়েছি';

  @override
  String get autoFillAiScanButton => 'AI স্ক্যান দিয়ে অটো ফিল করুন';

  @override
  String get savingLabel => 'সংরক্ষণ হচ্ছে...';

  @override
  String get savePlantButton => 'গাছ সংরক্ষণ করুন';

  @override
  String get tomorrowLabel => 'আগামীকাল';

  @override
  String get laterThisWeekLabel => 'এই সপ্তাহে পরে';

  @override
  String get careCalendarTitle => 'পরিচর্যা ক্যালেন্ডার';

  @override
  String get noCareTasksTitle => 'এখনো কোনো পরিচর্যার কাজ নেই';

  @override
  String get noCareTasksBody =>
      'পানি দেওয়ার সময়সূচি দেখতে একটি গাছ যোগ করুন।';

  @override
  String careTaskWater(String name) {
    return '$name-কে পানি দিন';
  }

  @override
  String careTaskFertilize(String name) {
    return '$name-এ সার দিন';
  }

  @override
  String get allCaughtUpTitle => 'সব করা হয়ে গেছে!';

  @override
  String get allCaughtUpBody => 'আপনার গাছেরা আপনাকে ধন্যবাদ জানাচ্ছে।';

  @override
  String get myPlantsTitle => 'আমার সবুজ পরিবার';

  @override
  String get searchPlantsHint => 'গাছ খুঁজুন...';

  @override
  String get statPlants => 'গাছ';

  @override
  String get statHealth => 'স্বাস্থ্য';

  @override
  String get statWaterToday => 'আজ পানি';

  @override
  String get noPlantsTitle => 'এখনো কোনো গাছ নেই';

  @override
  String get noPlantsBody => 'প্রথম গাছ যোগ করতে + চাপুন।';

  @override
  String plantWateredSnackbar(String name) {
    return '$name-কে পানি দেওয়া হয়েছে চিহ্নিত করা হলো';
  }

  @override
  String get deletePlantConfirmTitle => 'গাছটি মুছবেন?';

  @override
  String deletePlantConfirmBody(String name) {
    return '$name আপনার সংগ্রহ থেকে সরিয়ে ফেলা হবে।';
  }

  @override
  String get plantFallbackTitle => 'গাছ';

  @override
  String get plantNotFoundMessage => 'গাছটি পাওয়া যায়নি।';

  @override
  String get markAsWateredTooltip => 'পানি দেওয়া হয়েছে চিহ্নিত করুন';

  @override
  String get deletePlantMenuItem => 'গাছ মুছুন';

  @override
  String get todaysCareTitle => 'আজকের পরিচর্যা';

  @override
  String plantWaterLevelLabel(String level) {
    return 'পানি: $level';
  }

  @override
  String get noFertilizerNoteMessage => 'এখনো সারের কোনো নোট নেই';

  @override
  String plantFertilizeNoteLabel(String note) {
    return 'সার: $note';
  }

  @override
  String plantLastScanLabel(String when) {
    return 'সর্বশেষ স্ক্যান: $when';
  }

  @override
  String get scanAgainButton => 'আবার স্ক্যান করুন';

  @override
  String get askAiDoctorButton => 'AI ডাক্তারকে জিজ্ঞাসা করুন';

  @override
  String get plantHistoryTitle => 'গাছের ইতিহাস';

  @override
  String get noActivityTitle => 'এখনো কোনো কার্যক্রম নেই';

  @override
  String get noActivityBody => 'শুরু করতে একটি গাছ স্ক্যান করুন বা পানি দিন!';

  @override
  String historyScanEntry(String name) {
    return 'AI স্ক্যান • $name';
  }

  @override
  String historyWateredEntry(String name) {
    return 'পানি দেওয়া হয়েছে • $name';
  }

  @override
  String get notScannedYetLabel => 'এখনো স্ক্যান করা হয়নি';

  @override
  String healthCritical(int percent) {
    return '$percent% • সংকটাপন্ন';
  }

  @override
  String healthNeedsCare(int percent) {
    return '$percent% • পরিচর্যা প্রয়োজন';
  }

  @override
  String healthHealthy(int percent) {
    return '$percent% • সুস্থ';
  }

  @override
  String get settingsMenuLabel => 'সেটিংস';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String profileMemberSince(String year) {
    return '$year সাল থেকে প্ল্যান্ট প্যারেন্ট';
  }

  @override
  String get statAvgHealth => 'গড় স্বাস্থ্য';

  @override
  String get statBadges => 'ব্যাজ';

  @override
  String get quickMenuTitle => 'কুইক মেনু';

  @override
  String get chooseLanguageTitle => 'ভাষা বেছে নিন';

  @override
  String get aboutBody =>
      'সংস্করণ ১.০.০\n\nআপনার বন্ধুত্বপূর্ণ AI বাগান সহকারী — নিশ্চিন্তে আপনার গাছ স্ক্যান, ট্র্যাক ও পরিচর্যা করুন।';

  @override
  String get notificationsSectionTitle => 'নোটিফিকেশন';

  @override
  String get pushNotificationsLabel => 'পুশ নোটিফিকেশন';

  @override
  String get pushNotificationsSubtitle => 'সাধারণ অ্যাপ আপডেট ও সতর্কতা';

  @override
  String get wateringRemindersLabel => 'পানি দেওয়ার রিমাইন্ডার';

  @override
  String get wateringRemindersSubtitle => 'গাছে পানি প্রয়োজন হলে জানানো হবে';

  @override
  String get appearanceSectionTitle => 'চেহারা';

  @override
  String get darkModeLabel => 'ডার্ক মোড';

  @override
  String get generalSectionTitle => 'সাধারণ';

  @override
  String get languageLabel => 'ভাষা';

  @override
  String get aboutPlantPalLabel => 'PlantPal সম্পর্কে';

  @override
  String get accountSectionTitle => 'অ্যাকাউন্ট';

  @override
  String get logoutConfirmBody => 'আপনি কি লগ আউট করতে চান?';

  @override
  String get reviewsSectionTitle => 'রিভিউ';

  @override
  String get noReviewsMessage => 'এখনো কোনো রিভিউ নেই। প্রথম রিভিউ দিন!';

  @override
  String get writeReviewTitle => 'রিভিউ লিখুন';

  @override
  String get yourRatingLabel => 'আপনার রেটিং';

  @override
  String get reviewHintText => 'এই পণ্য নিয়ে আপনার অভিজ্ঞতা জানান...';

  @override
  String get submitReviewButton => 'রিভিউ জমা দিন';

  @override
  String get categoryAllLabel => 'সব';

  @override
  String get productFallbackTitle => 'পণ্য';

  @override
  String get productNotFoundMessage => 'পণ্যটি পাওয়া যায়নি।';

  @override
  String get detailsSectionTitle => 'বিস্তারিত';

  @override
  String get descriptionSectionTitle => 'বর্ণনা';

  @override
  String get quantitySectionTitle => 'পরিমাণ';

  @override
  String productQuantityFormula(int qty, String unit) {
    return '= $qty × $unit';
  }

  @override
  String get buyNowButton => 'এখনই কিনুন';

  @override
  String productReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি রিভিউ',
      zero: 'কোনো রিভিউ নেই',
    );
    return '$_temp0';
  }

  @override
  String productInStock(int count) {
    return '$countটি মজুদ আছে';
  }

  @override
  String get shopSubtitle => 'আপনার প্রয়োজনীয় বাগান সরঞ্জাম খুঁজুন';

  @override
  String get searchProductsHint => 'পণ্য খুঁজুন...';

  @override
  String get noProductsFoundMessage => 'কোনো পণ্য পাওয়া যায়নি';

  @override
  String productAddedToCartSnackbar(String name) {
    return '$name কার্টে যোগ করা হয়েছে';
  }

  @override
  String get wishlistTitle => 'আমার উইশলিস্ট';

  @override
  String get wishlistEmptyTitle => 'আপনার উইশলিস্ট খালি';

  @override
  String get wishlistEmptyBody =>
      'এখানে সংরক্ষণ করতে যেকোনো পণ্যের হার্ট আইকনে চাপুন।';

  @override
  String get browseShopButton => 'দোকান দেখুন';

  @override
  String get plantBotAnalyzingLabel => 'PlantBot বিশ্লেষণ করছে...';

  @override
  String get scanPlantTitle => 'আপনার গাছ স্ক্যান করুন';

  @override
  String get analyzingPlantLabel => 'আপনার গাছ বিশ্লেষণ করা হচ্ছে...';

  @override
  String get chooseFromGalleryButton => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get plantIdentifiedTitle => 'গাছ শনাক্ত হয়েছে';

  @override
  String get noScanYetTitle => 'এখনো স্ক্যান করা হয়নি';

  @override
  String get noScanYetBody => 'প্রথমে একটি গাছের ছবি তুলুন বা বেছে নিন।';

  @override
  String get unknownPlantLabel => 'অজানা গাছ';

  @override
  String get aiHardcodedLabel => 'পূর্বনির্ধারিত উত্তর';

  @override
  String get viewCareGuideButton => 'পরিচর্যা গাইড দেখুন';

  @override
  String get captionHint => 'ক্যাপশন যোগ করুন (ঐচ্ছিক)...';

  @override
  String get chatInputHint => 'যেকোনো কিছু জিজ্ঞাসা করুন...';

  @override
  String get aiVisionAnalysisTitle => 'AI ভিশন বিশ্লেষণ';

  @override
  String diagnosisProblemLabel(String issue) {
    return 'সমস্যা: $issue';
  }

  @override
  String diagnosisConfidenceSeverity(String confidence, String severity) {
    return 'নির্ভুলতা: $confidence | তীব্রতা: $severity';
  }

  @override
  String get treatmentLabel => 'চিকিৎসা:';

  @override
  String get recommendedFertilizerLabel => 'প্রস্তাবিত সার:';

  @override
  String get shopProductsLabel => 'দোকানের পণ্য:';

  @override
  String bulletItem(String item) {
    return '• $item';
  }

  @override
  String get aiDisclaimerText =>
      'এটি শুধুমাত্র AI-এর পরামর্শ — নিশ্চিত রোগনির্ণয় নয়। গুরুতর সমস্যায় স্থানীয় উদ্ভিদ বিশেষজ্ঞের পরামর্শ নিন।';

  @override
  String get chatWelcomeMessage =>
      'হ্যালো! আমি PlantBot।\nআজ আপনার গাছের জন্য আমি কীভাবে সাহায্য করতে পারি?';

  @override
  String get chatSuggestion1 => 'আমার পাতা হলুদ হয়ে যাচ্ছে কেন?';

  @override
  String get chatSuggestion2 => 'ঘরে তৈরি কলার সার';

  @override
  String get chatSuggestion3 => 'পাতার দাগের চিকিৎসা';

  @override
  String get chatRateLimitError =>
      'ফ্রি-টিয়ারের সীমা শেষ। অনুগ্রহ করে ১০ সেকেন্ড অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get signInRequiredChatMessage =>
      'PlantBot-এর সাথে চ্যাট করতে Google দিয়ে সাইন ইন করুন।';

  @override
  String get connectionErrorMessage =>
      'আমার প্ল্যান্ট নলেজ বেজের সাথে সংযোগ করতে সমস্যা হচ্ছে। আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get genericChatErrorMessage =>
      'এই অনুরোধে সমস্যা হয়েছে। আবার চেষ্টা করুন!';

  @override
  String get scanRateLimitError =>
      'সীমা শেষ হয়ে গেছে। অনুগ্রহ করে ১০ সেকেন্ড অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get signInRequiredScanMessage =>
      'গাছ স্ক্যান করতে Google দিয়ে সাইন ইন করুন।';

  @override
  String get scanAnalysisErrorMessage =>
      'এই ছবিটি বিশ্লেষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get plantDetailsTitle => 'গাছের বিবরণ';

  @override
  String get careSummaryTitle => 'পরিচর্যার সারসংক্ষেপ';

  @override
  String get actionsTitle => 'কার্যক্রম';

  @override
  String get lastWateredLabel => 'সর্বশেষ পানি দেওয়া হয়েছে';

  @override
  String get nextWaterLabel => 'পরবর্তী পানি দেওয়ার সময়';

  @override
  String get sunlightLabel => 'সূর্যালোক';

  @override
  String get neverWateredLabel => 'কখনো নয়';

  @override
  String get wateredTodayLabel => 'আজ';

  @override
  String daysAgoLabel(int days) {
    return '$days দিন আগে';
  }

  @override
  String get waterNowLabel => 'এখনই পানি দিন!';

  @override
  String daysLeftLabel(int days) {
    return '$days দিন পর';
  }

  @override
  String get unknownSpeciesLabel => 'অজানা প্রজাতি';

  @override
  String get noNicknameLabel => 'কোনো ডাকনাম নেই';

  @override
  String get markWateredButton => 'পানি দেওয়া হয়েছে চিহ্নিত করুন';

  @override
  String get editPlantButton => 'গাছের তথ্য সম্পাদনা';

  @override
  String markedWateredSnackbar(String name) {
    return '$name-এ পানি দেওয়া হয়েছে ';
  }

  @override
  String get needsWaterTooltip => 'পানি প্রয়োজন';

  @override
  String get emptyPlantsTitle => 'এখনো কোনো গাছ নেই';

  @override
  String get emptyPlantsBody => 'আপনার প্রথম গাছ যোগ করতে + চাপুন।';

  @override
  String get addFirstPlantButton => 'আপনার প্রথম গাছ যোগ করুন';

  @override
  String get plantsGridHeader => 'আমার গাছপালা';

  @override
  String get editPlantTitle => 'গাছের তথ্য পরিবর্তন';

  @override
  String get plantSavedSnackbar => 'গাছের তথ্য সফলভাবে সংরক্ষিত হয়েছে।';

  @override
  String get deleteConfirmTitle => 'এই গাছটি মুছে ফেলতে চান?';

  @override
  String get deleteConfirmBody => 'এই কাজটি আর ফিরিয়ে আনা যাবে না।';

  @override
  String get deletePlantButton => 'গাছ মুছুন';

  @override
  String get changePhotoLabel => 'ছবি পরিবর্তন করুন';

  @override
  String get settingsSectionTitle => 'সেটিংস';

  @override
  String get notificationsLabel => 'বিজ্ঞপ্তি';

  @override
  String get helpLabel => 'সাহায্য';

  @override
  String get aboutLabel => 'সম্পর্কে';

  @override
  String get profileStatPlants => 'গাছপালা';

  @override
  String get profileStatOrders => 'অর্ডার';

  @override
  String get profileStatPoints => 'পয়েন্ট';

  @override
  String get shopTitle => 'দোকান';

  @override
  String get allCategoryLabel => 'সব';

  @override
  String get noProductsFoundTitle => 'কোনো পণ্য পাওয়া যায়নি';

  @override
  String get noScanResultTitle => 'এখনো কোনো স্ক্যান নেই';

  @override
  String get noScanResultBody =>
      'প্রথমে একটি গাছের ছবি তুলুন বা নির্বাচন করুন।';

  @override
  String get defaultDisplayName => 'গাছের অভিভাবক';

  @override
  String get refreshPriceButton => 'AI দিয়ে দাম যাচাই করুন';

  @override
  String get checkingPriceLabel => 'সর্বশেষ দাম যাচাই করা হচ্ছে...';

  @override
  String get aiPriceRefreshedLabel => 'AI মূল্য যাচাই';

  @override
  String priceCheckedAgoLabel(String timeAgo) {
    return 'যাচাই করা হয়েছে $timeAgo';
  }

  @override
  String get possiblyOutOfStockLabel => 'স্টক শেষ হতে পারে';

  @override
  String get priceRefreshFailedLabel => 'সর্বশেষ মূল্য আনা যায়নি';

  @override
  String get refreshAgainLabel => 'আবার যাচাই করুন';

  @override
  String get retryLabel => 'পুনরায় চেষ্টা করুন';

  @override
  String get justNowLabel => 'এইমাত্র';

  @override
  String minutesAgoLabel(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgoLabel(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String get navHome => 'হোম';

  @override
  String get navScan => 'স্ক্যান';

  @override
  String get navShop => 'শপ';

  @override
  String get navAiDoctor => 'এআই ডাক্তার';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get myOrdersLabel => 'আমার অর্ডার';

  @override
  String get noOrdersTitle => 'এখনো কোনো অর্ডার নেই';

  @override
  String get noOrdersBody => 'আপনার দেওয়া অর্ডার এখানে দেখা যাবে।';

  @override
  String get markAsFertilizedTooltip => 'সার দেওয়া হয়েছে চিহ্নিত করুন';

  @override
  String plantFertilizedSnackbar(String name) {
    return '$name-কে সার দেওয়া হয়েছে চিহ্নিত করা হলো';
  }

  @override
  String get chatHistoryTooltip => 'চ্যাট ইতিহাস';

  @override
  String get chatSessionsTitle => 'আপনার চ্যাট';

  @override
  String get chatNewChat => 'নতুন চ্যাট';

  @override
  String get chatSessionsToday => 'আজ';

  @override
  String get chatSessionsYesterday => 'গতকাল';

  @override
  String get chatSessionsEarlier => 'আগের';

  @override
  String get chatSessionsEmptyTitle => 'এখনো কোনো চ্যাট নেই';

  @override
  String get chatSessionsEmptyBody =>
      'একটি কথোপকথন শুরু করুন, এখানে দেখা যাবে।';

  @override
  String get chatUntitledSession => 'নতুন কথোপকথন';

  @override
  String get chatDeleteConfirmTitle => 'এই চ্যাটটি মুছবেন?';

  @override
  String get chatDeleteConfirmBody => 'এই কথোপকথনটি স্থায়ীভাবে মুছে যাবে।';

  @override
  String get chatDeleteFailed => 'চ্যাটটি মুছতে পারিনি। আবার চেষ্টা করুন।';

  @override
  String get chatLoadHistoryError => 'এই চ্যাটটি লোড করা যায়নি।';

  @override
  String get chatStopTooltip => 'থামান';

  @override
  String get chatScanContextRemove => 'এই চ্যাট থেকে স্ক্যান সরান';

  @override
  String get chatPhotoUnavailable =>
      'ছবি পাওয়া যায়নি। আবার চেষ্টা করতে ট্যাপ করুন।';

  @override
  String chatScanPrefill(String issue) {
    return 'আমার গাছে $issue দেখা যাচ্ছে। আমার কী করা উচিত?';
  }
}
