import 'package:culture_app/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void toggleDarkMode() {
    state = Settings(
      darkMode: !state.darkMode,
      language: state.language,
      city: state.city,
    );
  }

  void setLanguage(String language) {
    state = Settings(
      darkMode: state.darkMode,
      language: language,
      city: state.city,
    );
  }

  void setCity(String city) {
    state = Settings(
      darkMode: state.darkMode,
      language: state.language,
      city: city,
    );
  }
}
