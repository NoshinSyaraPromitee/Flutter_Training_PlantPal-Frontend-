import 'app_localizations.dart';

/// English strings. Source of truth mirrored in app_en.arb.
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'PlantPal';
  @override
  String get appTagline => 'Your plant\'s best friend.';
  @override
  String get getStartedButton => 'Get Started';
  @override
  String get loadingLabel => 'Growing updates...';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get loginWelcomeBack => 'Welcome Back!';
  @override
  String get loginSubtitle => 'Your plants missed you!';
  @override
  String get emailLabel => 'Email Address';
  @override
  String get passwordLabel => 'Password';
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
  String get fullNameLabel => 'Full Name';

  @override
  String get profileTitle => 'Profile';
  @override
  String get profileStatPlants => 'Plants';
  @override
  String get statHealth => 'Overall Health';
  @override
  String get statWaterToday => 'Due Today';
  @override
  String get settingsSectionTitle => 'Settings';
  @override
  String get settingsMenuLabel => 'Settings';
  @override
  String get notificationsLabel => 'Notifications';
  @override
  String get onLabel => 'On';
  @override
  String get offLabel => 'Off';
  @override
  String get darkModeLabel => 'Dark Mode';
  @override
  String get accountSectionTitle => 'Account';
  @override
  String get myOrdersLabel => 'My Orders';
  @override
  String get helpLabel => 'Help';
  @override
  String get aboutLabel => 'About';
  @override
  String get logOutButton => 'Log Out';

  @override
  String get notificationsSectionTitle => 'Notifications';
  @override
  String get pushNotificationsLabel => 'Push Notifications';
  @override
  String get pushNotificationsSubtitle => 'Updates, plant tips, and announcements';
  @override
  String get wateringRemindersLabel => 'Watering Alerts';
  @override
  String get wateringRemindersSubtitle => 'Get notified exact moments your plants get thirsty';
  @override
  String get appearanceSectionTitle => 'Appearance';
  @override
  String get generalSectionTitle => 'General Settings';
  @override
  String get languageLabel => 'App Language';
  @override
  String get chooseLanguageTitle => 'Select Language';
  @override
  String get aboutPlantPalLabel => 'About PlantPal';
  @override
  String get aboutBody =>
      'Version 1.0.0\n\nYour intelligent plant companion—scan, care, and cultivate your home jungle with confidence.';
  @override
  String get closeButton => 'Close';
  @override
  String get myPlants => 'My Plants';
  @override
  String get aiDoctor => 'AI Doctor';
  @override
  String get fertilizerRecipes => 'Fertilizer Recipes';
  @override
  String get maintenance => 'Maintenance';
  @override
  String get shop => 'Shop';
  @override
  String get uploadPlantPhoto => "Upload your Plant's Photo";
  @override
  String get noNewNotifications => 'No new notifications.';

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
  String get settingsTitle => 'Settings';
  @override
  String get settingsAppearance => 'Appearance';
  @override
  String get settingsDarkMode => 'Dark mode';
  @override
  String get settingsLanguage => 'Language';
  @override
  String get settingsNotifications => 'Notifications';
  @override
  String get settingsWateringReminders => 'Watering reminders';
  @override
  String get settingsLogout => 'Log out';

  @override
  String get landingTitle => 'PlantPal';
  @override
  String get landingSubtitle => "Your Garden's best Friend";
  @override
  String get landingLogin => 'Log In';
  @override
  String get landingRegister => 'Create Account';

  @override
  String get loginTitle => 'Welcome back';
  @override
  String get loginEmail => 'Email';
  @override
  String get loginPassword => 'Password';
  @override
  String get loginSubmit => 'Log In';

  @override
  String get registerTitle => 'Create your account';
  @override
  String get registerSubmit => 'Sign Up';

  @override
  String get cancel => 'Cancel';
  @override
  String get delete => 'Delete';
  @override
  String get save => 'Save';

  @override
  String get greetingMorning => 'Good morning! ☀️ Ready to check on your plants?';
  @override
  String get greetingAfternoon => 'Good afternoon! 🌤️ How are your plants doing?';
  @override
  String get greetingEvening => 'Good evening! 🌆 Time for one last check-in.';
  @override
  String get greetingNight => 'Still up? 🌙 Your plants are resting too.';
  @override
  String get greetingPlantThirsty => '🌱 One of your plants is thirsty today!';
  @override
  String get greetingWeatherRain => "It's rainy out there 🌧️ — skip watering outdoor plants today.";
  @override
  String get greetingWeatherThunderstorm => 'Storms nearby ⛈️ — keep sensitive plants indoors.';
  @override
  String get greetingWeatherSnow => "It's snowing ❄️ — bring tender plants inside.";
  @override
  String get greetingWeatherFog => 'Foggy morning 🌫️ — your plants love the extra humidity.';
  @override
  String greetingWeatherHot(int temperature) => "It's $temperature°C out 🔥 — your plants may need extra water.";

  @override
  String weatherTipHot(int waterMl) => "It's too hot today 🔥 — give at least $waterMl ml water today.";
  @override
  String get weatherTipCold => "It's cold today ❄️ — water a little less to avoid root rot.";
  @override
  String get weatherTipWetOutside => "It's wet outside today 🌧️ — skip watering outdoor plants.";

  @override
  String pointsBalanceLabel(String points, String taka) => '$points pts ($taka ৳)';
  @override
  String get noNotificationsMessage => "You're all caught up! No new notifications.";
  @override
  String get uploadPlantPhotoPrompt => 'Snap or upload a photo';
  @override
  String get myPlantsMenuLabel => 'My Garden';
  @override
  String get aiDoctorMenuLabel => 'AI Plant Doctor';
  @override
  String get maintenanceMenuLabel => 'Care Schedules';
  @override
  String get fertilizerRecipesMenuLabel => 'DIY Plant Food';
  @override
  String get shopMenuLabel => 'Garden Shop';
  @override
  String mascotThirstyMessage(String mascotName) => '$mascotName is looking thirsty—time for a drink!';
}
