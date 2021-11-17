import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => _SharedPrefs(ref.read));
final _sharefPregerencesProvider = Provider((ref) async => await SharedPreferences.getInstance());

class _SharedPrefs {
  const _SharedPrefs(this._read);

  final Reader _read;

  ///
  /// テーマモードの設定
  ///
  Future<bool> isDarkMode() async => await _getBool('key001', defaultValue: false);
  Future<void> saveDarkMode(bool value) async {
    await _saveBool('key001', value);
  }

  ///
  /// 前回イベントデータ取得日付
  ///
  Future<DateTime?> getPrevSaveEventDate() async {
    final dateStr = await _getString('key002');
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    } else {
      return null;
    }
  }

  Future<void> savePreviousGetEventDate(DateTime value) async {
    // これ別にyyyy-MM-ddの形式でなくても良い
    final monthStr = value.month.toString().padLeft(2, '0');
    final dayStr = value.day.toString().padLeft(2, '0');
    final saveStr = '${value.year}-$monthStr-$dayStr';
    await _saveString('key002', saveStr);
  }

  Future<String?> _getString(String key) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getString(key);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setString(key, value);
  }

  Future<bool> _getBool(String key, {required bool defaultValue}) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setBool(key, value);
  }

  static const _previousEventGetDate = 'PREVIOUS_EVENT_GET_DATA';
}
