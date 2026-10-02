class AppConfig {
  AppConfig._();

  // `--dart-define=API_BASE_URL=http://10.0.2.2:8081` there instead.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8081',
  );

  static const googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue:
        '441074426973-seg14od7d8apt3u4ahfk83j0ihkjshka.apps.googleusercontent.com',
  );

  static const googleRedirectUri = String.fromEnvironment(
    'GOOGLE_REDIRECT_URI',
    defaultValue: 'https://ifingi.biz:8134/auth/google/callback',
  );

  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: googleClientId,
  );

  static const passwordResetEnabled = false;

  static const appCallbackScheme = 'plantpal';
  static const appCallbackUri = 'plantpal://auth';
}
