import 'package:dyphic/common/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataSource {
  const AppDataSource._();

  ///
  /// このクラスを使用する場合はアプリ起動時に必ず1回initを呼ぶ
  ///
  factory AppDataSource.getInstance() {
    return _instance;
  }

  static AppDataSource _instance = AppDataSource._();
  static const _darkModeKey = 'DARK_MODE';
  static const _previousEventGetDate = 'PREVIOUS_EVENT_GET_DATA';

  static SharedPreferences _prefs;

  Future<void> init() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  bool isDarkMode() {
    if (_prefs.containsKey(_darkModeKey)) {
      return _prefs.getBool(_darkModeKey);
    } else {
      return false;
    }
  }

  Future<void> saveDarkMode() async {
    await _prefs.setBool(_darkModeKey, true);
  }

  Future<void> saveLightMode() async {
    await _prefs.setBool(_darkModeKey, false);
  }

  Future<DateTime> getPrevSaveEventDate() async {
    if (_prefs.containsKey(_previousEventGetDate)) {
      final dateStr = _prefs.getString(_previousEventGetDate);
      AppLogger.i('前回イベント情報を保存した日付を取得しました。\n  取得した日付: $dateStr');
      return DateTime.parse(dateStr);
    }
    return null;
  }

  Future<void> saveSaveGetEventDate() async {
    final nowDate = DateTime.now();
    final monthStr = nowDate.month.toString().padLeft(2, '0');
    final dayStr = nowDate.day.toString().padLeft(2, '0');
    final dateStr = '${nowDate.year}-$monthStr-$dayStr';
    await _prefs.setString(_previousEventGetDate, dateStr);
  }
}
