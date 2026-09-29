import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();
  // 10.0.2.2 is the Android-emulator-only alias for the host machine's localhost;
  // real devices / iOS simulator need a different host value (e.g. your machine's LAN IP).
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb ? 'http://localhost:8081' : 'http://10.0.2.2:8081',
  );

  /// The OAuth *Web application* client ID from Google Cloud Console. Google Sign-In
  /// puts it in the ID token's audience, and the backend (GOOGLE_CLIENT_ID) checks it.
  /// Android uses it as serverClientId; on web it is the clientId of the Google button.
  /// Pass it at build time: --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '818489842071-smbaue5m8tc7kl8iqhd9k2jo66olljtk.apps.googleusercontent.com',
  );
}
