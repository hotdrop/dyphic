import 'package:dyphic/repository/local/app_data_source.dart';
import 'package:dyphic/service/app_firebase.dart';

///
/// アプリの設定に関する情報は全てここから取得する
///
class AppSettingsRepository {
  const AppSettingsRepository._();

  static Future<AppSettingsRepository> create({AppDataSource argAppDs, AppFirebase argFirebase}) async {
    final instance = AppSettingsRepository._();
    await instance._init(argAppDs, argFirebase);
    return instance;
  }

  static AppDataSource _appDataSource;

  Future<void> _init(AppDataSource appDataSource, AppFirebase appFirebase) async {
    _appDataSource = appDataSource ?? AppDataSource.create();
    await _appDataSource.init();

    final _firebase = appFirebase ?? AppFirebase.getInstance();
    await _firebase.load();
  }

  bool isDarkMode() => _appDataSource == null ? false : _appDataSource.isDarkMode();

  Future<void> changeDarkMode() async {
    await _appDataSource.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _appDataSource.saveLightMode();
  }
}
