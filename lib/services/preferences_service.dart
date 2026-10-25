import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class PreferencesService {
  static const String _defaultLanguage = 'ru';

  static const Set<String> _supportedLanguages = {
    'ru',
    'en',
  };

  Future<bool> isDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(AppConstants.prefDisclaimerAccepted) ?? false;
  }

  Future<void> setDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      AppConstants.prefDisclaimerAccepted,
      true,
    );
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final language =
        prefs.getString(AppConstants.prefLanguage) ?? _defaultLanguage;

    return _supportedLanguages.contains(language) ? language : _defaultLanguage;
  }

  Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();

    final language =
        _supportedLanguages.contains(code) ? code : _defaultLanguage;

    await prefs.setString(
      AppConstants.prefLanguage,
      language,
    );
  }
}
