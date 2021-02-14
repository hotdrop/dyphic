import 'package:dalico/repository/local/shared_prefs.dart';

///
/// アプリの設定に関する情報は全てここから取得する
///
class AppSettingsRepository {
  const AppSettingsRepository._(this._prefs);

  static Future<AppSettingsRepository> getInstance({SharedPrefs argPrefs}) async {
    if (_instance == null) {
      final prefs = argPrefs != null ? argPrefs : await SharedPrefs.getInstance();
      _instance = AppSettingsRepository._(prefs);
    }
    return _instance;
  }

  static AppSettingsRepository _instance;
  final SharedPrefs _prefs;

  bool isDarkMode() => _prefs == null ? false : _prefs.isDarkMode();

  Future<void> changeDarkMode() async {
    await _prefs.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _prefs.saveLightMode();
  }
}
