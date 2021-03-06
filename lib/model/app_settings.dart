import 'package:dyphic/repository/local/app_data_source.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/repository/app_settings_repository.dart';

///
/// アプリ全体の設定はこのモデルクラスからアクセスする
/// 起動時に必要な処理も全てここで行う
///
class AppSettings extends ChangeNotifier {
  AppSettings._(this._repository);

  static Future<AppSettings> create() async {
    // ここでアプリで必要な初期化を全て行う
    final dataSource = AppDataSource.getInstance();
    await dataSource.init();

    final firebase = AppFirebase.getInstance();
    await firebase.init();

    return AppSettings._(AppSettingsRepository.create());
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
