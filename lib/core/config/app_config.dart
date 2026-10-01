class AppConfig {
  AppConfig._();

  // Default matches the Go backend's actual port (see backend/internal/config
  // and docker-compose.yml — 8081, not Flutter's own default 8080) and
  // `localhost`, which works for Chrome/desktop. Android emulator can't
  // reach `localhost` for the host machine — override with
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

  // Must exactly match GOOGLE_REDIRECT_URI in the backend's .env and the
  // redirect URI registered on the Web OAuth client in Google Cloud
  // Console - Google rejects the code exchange otherwise.
  static const googleRedirectUri = String.fromEnvironment(
    'GOOGLE_REDIRECT_URI',
    defaultValue: 'https://ifingi.biz:8134/auth/google/callback',
  );

  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: googleClientId,
  );

  static const appCallbackScheme = 'plantpal';
  static const appCallbackUri = 'plantpal://auth';
}
