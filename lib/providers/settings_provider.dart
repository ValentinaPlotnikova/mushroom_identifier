import 'package:flutter/foundation.dart';

import '../models/user_settings.dart';
import '../services/firestore_service.dart';
import '../services/preferences_service.dart';

class SettingsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final PreferencesService _prefs = PreferencesService();

  UserSettings _settings = const UserSettings();
  bool _isLoading = false;
  String? _uid;

  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> load(String uid) async {
    _uid = uid;
    _isLoading = true;
    notifyListeners();
    try {
      _settings = await _firestoreService.getSettings(uid);
      await _prefs.setLanguage(_settings.language);
    } catch (_) {
      _settings = const UserSettings();
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> setLanguage(String language) async {
    if (language != 'ru' && language != 'en') return;

    _settings = _settings.copyWith(language: language);

    notifyListeners();

    await _prefs.setLanguage(language);

    if (_uid != null) {
      await _firestoreService.updateSettings(
        _uid!,
        _settings,
      );
    }
  }

  Future<void> setNotifications(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await _persist();
  }

  Future<void> setGeolocation(bool enabled) async {
    _settings = _settings.copyWith(geolocationEnabled: enabled);
    await _persist();
  }

  Future<void> _persist() async {
    notifyListeners();
    if (_uid != null) {
      await _firestoreService.updateSettings(_uid!, _settings);
    }
  }

  void reset() {
    _settings = const UserSettings();
    _uid = null;
    notifyListeners();
  }
}
