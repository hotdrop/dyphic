import 'package:dyphic/repository/local/app_data_source.dart';

///
/// アプリの設定に関する情報は全てここから取得する
///
class AppSettingsRepository {
  const AppSettingsRepository._();

  static Future<AppSettingsRepository> create({AppDataSource argAppDs}) async {
    final instance = AppSettingsRepository._();
    await instance._init(appDataSource: argAppDs);
    return instance;
  }

  static AppDataSource _appDataSource;

  Future<void> _init({AppDataSource appDataSource}) async {
    _appDataSource = appDataSource ?? AppDataSource.create();
    await _appDataSource.init();
  }

  bool isDarkMode() => _appDataSource == null ? false : _appDataSource.isDarkMode();

  Future<void> changeDarkMode() async {
    await _appDataSource.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _appDataSource.saveLightMode();
  }
}
