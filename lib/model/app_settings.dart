import 'package:flutter/material.dart';

import 'package:dalico/repository/app_settings_repository.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._(this._repo);

  static Future<AppSettings> create({AppSettingsRepository argRepo}) async {
    final repo = argRepo != null ? argRepo : await AppSettingsRepository.getInstance();
    return AppSettings._(repo);
  }

  AppSettingsRepository _repo;

  bool get isDarkMode => _repo.isDarkMode();

  Future<void> setLightTheme() async {
    await _repo.changeLightMode();
    notifyListeners();
  }

  Future<void> setDarkTheme() async {
    await _repo.changeDarkMode();
    notifyListeners();
  }
}
