import 'app_localizations.dart';

/// English strings. Source of truth mirrored in app_en.arb.
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'PlantPal';
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
}
