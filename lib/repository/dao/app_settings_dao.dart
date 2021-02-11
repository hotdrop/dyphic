import 'package:dalico/common/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsDao {
  AppSettingsDao._(this._prefs);

  static Future<AppSettingsDao> getInstance({SharedPreferences argPrefs}) async {
    if (_instance == null) {
      final prefs = argPrefs != null ? argPrefs : await SharedPreferences.getInstance();
      _instance = AppSettingsDao._(prefs);
    }
    return _instance;
  }

  static AppSettingsDao _instance;
  SharedPreferences _prefs;

  static const _darkModeKey = 'DARK_MODE';

  bool isDarkMode() {
    if (_prefs.containsKey(_darkModeKey)) {
      AppLogger.i('sharedにダークモード設定が保存されているのでそれを取得します。');
      return _prefs.getBool(_darkModeKey);
    } else {
      AppLogger.i('sharedにダークモード設定が保存されていないのでライトモードと判定します。');
      return false;
    }
  }

  Future<void> saveDarkMode() async {
    AppLogger.i('ダークモードで保存します。');
    await _prefs.setBool(_darkModeKey, true);
  }

  Future<void> saveLightMode() async {
    AppLogger.i('ライトモードで保存します。');
    await _prefs.setBool(_darkModeKey, false);
  }
}
