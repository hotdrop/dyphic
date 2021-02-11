import 'package:dalico/repository/dao/app_settings_dao.dart';

class AppSettingsRepository {
  AppSettingsRepository._(this._dao);

  static Future<AppSettingsRepository> getInstance({AppSettingsDao argDao}) async {
    if (_instance == null) {
      final dao = argDao != null ? argDao : await AppSettingsDao.getInstance();
      _instance = AppSettingsRepository._(dao);
    }
    return _instance;
  }

  static AppSettingsRepository _instance;
  AppSettingsDao _dao;

  bool isDarkMode() => _dao == null ? false : _dao.isDarkMode();

  Future<void> changeDarkMode() async {
    await _dao.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _dao.saveLightMode();
  }
}
