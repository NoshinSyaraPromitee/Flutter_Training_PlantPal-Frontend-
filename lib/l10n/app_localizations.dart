import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'package:flutter/foundation.dart'; // add this — for SynchronousFuture


abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(l != null, 'No AppLocalizations found in context. Did you add AppLocalizations.delegate?');
    return l!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('bn')];

  // ---- Strings ----
  String get appTitle;
  String get myPlants;
  String get aiDoctor;
  String get fertilizerRecipes;
  String get maintenance;
  String get shop;
  String get uploadPlantPhoto;
  String get noNewNotifications;

  String get navHome;
  String get navScan;
  String get navShop;
  String get navAiDoctor;
  String get navProfile;

  String get settingsTitle;
  String get settingsAppearance;
  String get settingsDarkMode;
  String get settingsLanguage;
  String get settingsNotifications;
  String get settingsWateringReminders;
  String get settingsLogout;

  String get landingTitle;
  String get landingSubtitle;
  String get landingLogin;
  String get landingRegister;

  String get loginTitle;
  String get loginEmail;
  String get loginPassword;
  String get loginSubmit;

  String get registerTitle;
  String get registerSubmit;

  String get cancel;
  String get delete;
  String get save;

  String get greetingMorning;
  String get greetingAfternoon;
  String get greetingEvening;
  String get greetingNight;
  String get greetingPlantThirsty;
  String get greetingWeatherRain;
  String get greetingWeatherThunderstorm;
  String get greetingWeatherSnow;
  String get greetingWeatherFog;
  String greetingWeatherHot(int temperature);

  String weatherTipHot(int waterMl);
  String get weatherTipCold;
  String get weatherTipWetOutside;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'bn':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsBn());
      case 'en':
      default:
        return SynchronousFuture<AppLocalizations>(AppLocalizationsEn());
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
