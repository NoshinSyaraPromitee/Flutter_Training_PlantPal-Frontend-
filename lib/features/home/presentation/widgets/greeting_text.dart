import 'package:plantpal/features/home/domain/greeting.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// Maps a [Greeting] to its localized speech-bubble text.
String greetingText(AppLocalizations t, Greeting greeting) {
  switch (greeting.kind) {
    case GreetingKind.morning:
      return t.greetingMorning;
    case GreetingKind.afternoon:
      return t.greetingAfternoon;
    case GreetingKind.evening:
      return t.greetingEvening;
    case GreetingKind.night:
      return t.greetingNight;
    case GreetingKind.plantThirsty:
      return t.greetingPlantThirsty;
    case GreetingKind.weatherRain:
      return t.greetingWeatherRain;
    case GreetingKind.weatherThunderstorm:
      return t.greetingWeatherThunderstorm;
    case GreetingKind.weatherSnow:
      return t.greetingWeatherSnow;
    case GreetingKind.weatherFog:
      return t.greetingWeatherFog;
    case GreetingKind.weatherHot:
      return t.greetingWeatherHot(greeting.temperatureC!);
  }
}
