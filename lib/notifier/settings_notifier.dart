import 'package:culture_app/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    _loadSettingsFromPrefs();
  }

  Future<void> _loadSettingsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = Settings(
      darkMode: prefs.getBool('darkMode') ?? false,
      language: prefs.getString('language') ?? 'de',
      city: prefs.getString('city') ?? 'Heilbronn',
    );
  }

  Future<void> _saveSettingsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', state.darkMode);
    await prefs.setString('language', state.language);
    await prefs.setString('city', state.city);
  }

  void toggleDarkMode() async {
    state = Settings(
      darkMode: !state.darkMode,
      language: state.language,
      city: state.city,
    );
    await _saveSettingsToPrefs();
  }

  void setLanguage(String language) async {
    state = Settings(
      darkMode: state.darkMode,
      language: language,
      city: state.city,
    );
    await _saveSettingsToPrefs();
  }

  void setCity(String city) async {
    state = Settings(
      darkMode: state.darkMode,
      language: state.language,
      city: city,
    );
    await _saveSettingsToPrefs();
  }
}
