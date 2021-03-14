import 'package:dyphic/repository/local/app_data_source.dart';
import 'package:dyphic/service/app_firebase.dart';

class AppSettingsRepository {
  const AppSettingsRepository._(this._appFirebase, this._prefs);

  factory AppSettingsRepository.create() {
    return AppSettingsRepository._(AppFirebase.instance, AppDataSource.getInstance());
  }

  final AppFirebase _appFirebase;
  final AppDataSource _prefs;

  bool isLogIn() => _appFirebase.isLogIn;
  bool isDarkMode() => _prefs.isDarkMode();

  Future<void> changeDarkMode() async {
    await _prefs.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _prefs.saveLightMode();
  }
}
