# PlantPal Flutter App

## Run locally in Chrome

Start the backend first. The Flutter web app uses `http://localhost:8081` as its
default API URL.

From the Flutter project directory, run:

```powershell
flutter pub get
flutter run -d chrome --web-port=5000
```

Keep the web port at `5000` for Google Sign-In. The Google Cloud web OAuth
client already has `http://localhost:5000` listed under **Authorized JavaScript
origins**. Google checks the exact origin (scheme, hostname, and port), and
does not support a wildcard port. If you use another port, that exact origin
must also be added to the OAuth client.

The web client ID is configured in the app, so no `GOOGLE_SERVER_CLIENT_ID`
define is needed for this local run.
