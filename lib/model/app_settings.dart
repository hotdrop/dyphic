import 'package:flutter/material.dart';

import 'package:dyphic/repository/app_settings_repository.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._(this._repository);

  static Future<AppSettings> create({AppSettingsRepository argRepo}) async {
    final repo = argRepo ?? await AppSettingsRepository.create();
    return AppSettings._(repo);
  }

  final AppSettingsRepository _repository;

  bool get isDarkMode => _repository.isDarkMode();

  Future<void> changeTheme(bool isDark) async {
    if (isDark) {
      await _repository.changeDarkMode();
    } else {
      await _repository.changeLightMode();
    }
    notifyListeners();
  }
}
