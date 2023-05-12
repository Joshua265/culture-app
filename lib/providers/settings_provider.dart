import 'package:culture_app/models/settings.dart';
import 'package:culture_app/notifier/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});
