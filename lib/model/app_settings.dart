import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/repository/app_settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSettingsProvider = StateNotifierProvider<_AppSettingsNotifier, AppSettings>((ref) => _AppSettingsNotifier(ref.read));

class _AppSettingsNotifier extends StateNotifier<AppSettings> {
  _AppSettingsNotifier(this._read) : super(AppSettings.create());

  final Reader _read;

  ///
  /// アプリ起動時に一回だけ呼ぶ
  ///
  Future<void> init() async {
    await _read(appFirebaseProvider).init();
    await _read(localDataSourceProvider).init();
    // 必要なデータをロード
    if (_read(conditionsProvider).isEmpty) {
      await _read(conditionsProvider.notifier).onLoad();
    }
    if (_read(medicineProvider).isEmpty) {
      await _read(medicineProvider.notifier).onLoad();
    }
    refresh();
  }

  Future<void> refresh() async {
    final isDarkMode = await _read(appSettingsRepositoryProvider).isDarkMode();
    state = AppSettings.create(
      mode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      isSignIn: _read(accountRepositoryProvider).isSignIn,
    );
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
  const AppSettings(this._currentMode, this.isSignIn);

  factory AppSettings.create({ThemeMode? mode, bool? isSignIn}) {
    final currentMode = mode ?? ThemeMode.system;
    return AppSettings(currentMode, isSignIn ?? false);
  }

  final ThemeMode _currentMode;
  final bool isSignIn;

  bool get isDarkMode => _currentMode == ThemeMode.dark;

  AppSettings copyWith(ThemeMode currentMode, {bool? isSignIn}) {
    return AppSettings(
      currentMode,
      isSignIn ?? this.isSignIn,
    );
  }
}
