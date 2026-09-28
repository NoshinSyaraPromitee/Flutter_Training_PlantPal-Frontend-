import 'package:flutter/foundation.dart';
import '../../../../core/storage/secure_storage.dart';

class SettingsController extends ChangeNotifier {
  SettingsController([this._storage]);
  final SecureStorage? _storage;

  bool notifications = true;
  bool wateringReminders = true;
  bool darkMode = false;
  String language = 'en';

  static const languages = {'en': 'English', 'bn': 'বাংলা (Bangla)'};

  Future<void> init() async {
    final savedLang = await _storage?.readLanguage();
    if (savedLang != null && languages.containsKey(savedLang)) {
      language = savedLang;
      notifyListeners();
    }
  }

  void setNotifications(bool v) => _set(() => notifications = v);
  void setWateringReminders(bool v) => _set(() => wateringReminders = v);
  void setDarkMode(bool v) => _set(() => darkMode = v);
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