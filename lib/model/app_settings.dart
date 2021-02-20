import 'package:flutter/material.dart';

import 'package:dyphic/repository/app_settings_repository.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._(this._repo);

  static Future<AppSettings> create({AppSettingsRepository argRepo}) async {
    final repo = argRepo != null ? argRepo : await AppSettingsRepository.getInstance();
    return AppSettings._(repo);
  }

  AppSettingsRepository _repo;

  bool get isDarkMode => _repo.isDarkMode();

  Future<void> changeTheme(bool isDark) async {
    if (isDark) {
      await _repo.changeDarkMode();
    } else {
      await _repo.changeLightMode();
    }
    notifyListeners();
  }
}
