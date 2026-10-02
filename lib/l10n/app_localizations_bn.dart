import 'app_localizations.dart';

/// Bangla (বাংলা) strings. Source of truth mirrored in app_bn.arb.
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn() : super('bn');

  @override
  String get appTitle => 'প্ল্যান্টপাল';
  @override
  String get myPlants => 'আমার গাছপালা';
  @override
  String get aiDoctor => 'এআই ডাক্তার';
  @override
  String get fertilizerRecipes => 'সারের রেসিপি';
  @override
  String get maintenance => 'রক্ষণাবেক্ষণ';
  @override
  String get shop => 'দোকান';
  @override
  String get uploadPlantPhoto => 'আপনার গাছের ছবি আপলোড করুন';
  @override
  String get noNewNotifications => 'নতুন কোনো বিজ্ঞপ্তি নেই।';

  @override
  String get navHome => 'হোম';
  @override
  String get navScan => 'স্ক্যান';
  @override
  String get navShop => 'দোকান';
  @override
  String get navAiDoctor => 'এআই ডাক্তার';
  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get settingsTitle => 'সেটিংস';
  @override
  String get settingsAppearance => 'অ্যাপিয়ারেন্স';
  @override
  String get settingsDarkMode => 'ডার্ক মোড';
  @override
  String get settingsLanguage => 'ভাষা';
  @override
  String get settingsNotifications => 'বিজ্ঞপ্তি';
  @override
  String get settingsWateringReminders => 'পানি দেওয়ার রিমাইন্ডার';
  @override
  String get settingsLogout => 'লগ আউট';

  @override
  String get landingTitle => 'প্ল্যান্টপাল';
  @override
  String get landingSubtitle => 'আপনার বাগানের সেরা বন্ধু';
  @override
  String get landingLogin => 'লগ ইন';
  @override
  String get landingRegister => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get loginTitle => 'স্বাগতম';
  @override
  String get loginEmail => 'ইমেইল';
  @override
  String get loginPassword => 'পাসওয়ার্ড';
  @override
  String get loginSubmit => 'লগ ইন';

  @override
  String get registerTitle => 'আপনার অ্যাকাউন্ট তৈরি করুন';
  @override
  String get registerSubmit => 'সাইন আপ';

  @override
  String get cancel => 'বাতিল';
  @override
  String get delete => 'মুছুন';
  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get greetingMorning => 'শুভ সকাল! ☀️ আপনার গাছগুলো দেখে নিন?';
  @override
  String get greetingAfternoon => 'শুভ অপরাহ্ন! 🌤️ আপনার গাছগুলো কেমন আছে?';
  @override
  String get greetingEvening => 'শুভ সন্ধ্যা! 🌆 শেষবারের মতো একবার দেখে নিন।';
  @override
  String get greetingNight => 'এখনও জেগে আছেন? 🌙 আপনার গাছগুলোও বিশ্রাম নিচ্ছে।';
  @override
  String get greetingPlantThirsty => '🌱 আপনার একটি গাছের আজ পানি দরকার!';
  @override
  String get greetingWeatherRain => 'বাইরে বৃষ্টি হচ্ছে 🌧️ — আজ বাইরের গাছে পানি দেওয়ার দরকার নেই।';
  @override
  String get greetingWeatherThunderstorm => 'কাছাকাছি ঝড় হচ্ছে ⛈️ — সংবেদনশীল গাছগুলো ঘরে রাখুন।';
  @override
  String get greetingWeatherSnow => 'তুষারপাত হচ্ছে ❄️ — নরম গাছগুলো ঘরে নিয়ে আসুন।';
  @override
  String get greetingWeatherFog => 'কুয়াশাচ্ছন্ন সকাল 🌫️ — আপনার গাছগুলো এই বাড়তি আর্দ্রতা পছন্দ করে।';
  @override
  String greetingWeatherHot(int temperature) => 'বাইরে $temperature°সে তাপমাত্রা 🔥 — আপনার গাছের বাড়তি পানি লাগতে পারে।';

  @override
  String weatherTipHot(int waterMl) => 'আজ খুব গরম 🔥 — আজ অন্তত $waterMl মিলি পানি দিন।';
  @override
  String get weatherTipCold => 'আজ ঠান্ডা ❄️ — মূল পচন এড়াতে একটু কম পানি দিন।';
  @override
  String get weatherTipWetOutside => 'আজ বাইরে ভেজা আবহাওয়া 🌧️ — বাইরের গাছে পানি দেওয়ার দরকার নেই।';

  @override
  String pointsBalanceLabel(String points, String taka) => '$points পয়েন্ট ( $taka টাকা)';
  @override
  String get noNotificationsMessage => 'নতুন কোনো নোটিফিকেশন নেই।';
  @override
  String get uploadPlantPhotoPrompt => 'আপনার গাছের ছবি আপলোড করুন';
  @override
  String get myPlantsMenuLabel => 'আমার গাছ';
  @override
  String get aiDoctorMenuLabel => 'AI ডাক্তার';
  @override
  String get maintenanceMenuLabel => 'রক্ষণাবেক্ষণ';
  @override
  String get fertilizerRecipesMenuLabel => 'সারের রেসিপি';
  @override
  String get shopMenuLabel => 'দোকান';
  @override
  String mascotThirstyMessage(String mascotName) => '$mascotName তৃষ্ণার্ত, একটু পানি দিন';
}
