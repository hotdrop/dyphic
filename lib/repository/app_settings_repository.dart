import 'package:dyphic/repository/local/app_data_source.dart';

class AppSettingsRepository {
  const AppSettingsRepository._(this._prefs);

  factory AppSettingsRepository.create() {
    return AppSettingsRepository._(AppDataSource.getInstance());
  }

  final AppDataSource _prefs;

  bool isDarkMode() => _prefs == null ? false : _prefs.isDarkMode();

  Future<void> changeDarkMode() async {
    await _prefs.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _prefs.saveLightMode();
  }
}
