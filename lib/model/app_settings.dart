import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/repository/app_settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSettingsProvider = StateNotifierProvider<_AppSettingsNotifier, AppSettings>((ref) => _AppSettingsNotifier(ref.read));

class _AppSettingsNotifier extends StateNotifier<AppSettings> {
  _AppSettingsNotifier(this._read) : super(const AppSettings());

  final Reader _read;

  ///
  /// アプリ起動時に一回だけ呼ぶ
  ///
  Future<void> init() async {
    await _read(localDataSourceProvider).init();
    refresh();
  }

  Future<void> refresh() async {
    final isDarkMode = await _read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = AppSettings(currentMode: mode);
  }

  Future<void> changeTheme(bool isDark) async {
    if (isDark) {
      await _read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await _read(appSettingsRepositoryProvider).changeLightMode();
    }
    await refresh();
  }
}

class AppSettings {
  const AppSettings({this.currentMode = ThemeMode.system});

  final ThemeMode currentMode;

  bool get isDarkMode => currentMode == ThemeMode.dark;

  AppSettings copyWith({ThemeMode? currentMode}) {
    return AppSettings(
      currentMode: currentMode ?? this.currentMode,
    );
  }
}
