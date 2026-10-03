import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsController extends ChangeNotifier {
  SettingsController([this._storage]);
  final SecureStorage? _storage;

  static const _darkModeKey = 'settings_dark_mode';

  bool notifications = true;
  bool wateringReminders = true;
  bool darkMode = false;
  String language = 'en';

  static const languages = {
    'en': 'English',
    'bn': '\u09AC\u09BE\u0982\u09B2\u09BE (Bangla)',
  };

  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  /// Restores saved theme and language. Call once at startup.
  Future<void> load() async {
    final dark = await _storage?.read(_darkModeKey);
    darkMode = dark == 'true';
    AppColors.isDark = darkMode;
    final savedLang = await _storage?.readLanguage();
    if (savedLang != null && languages.containsKey(savedLang)) {
      language = savedLang;
    }
    notifyListeners();
  }

  Future<void> init() => load();

  void setNotifications(bool v) => _set(() => notifications = v);
  void setWateringReminders(bool v) => _set(() => wateringReminders = v);

  void setDarkMode(bool v) {
    darkMode = v;
    AppColors.isDark = v;
    _storage?.write(_darkModeKey, v.toString());
    notifyListeners();
  }

  void setLanguage(String code) {
    if (!languages.containsKey(code)) return;
    _set(() {
      language = code;
      _storage?.saveLanguage(code);
    });
  }

  void _set(VoidCallback change) {
    change();
    notifyListeners();
  }
}