import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:package_info/package_info.dart';

import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class SettingsViewModel extends NotifierViewModel {
  SettingsViewModel._(this._repository) {
    _init();
  }

  factory SettingsViewModel.create() {
    return SettingsViewModel._(AccountRepository.create());
  }

  final AccountRepository _repository;
  late PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  // ステータス
  _LoginStatus _loginStatus = _LoginStatus.notLogin;
  bool get loggedIn => _loginStatus == _LoginStatus.loggedIn;

  Future<void> _init() async {
    _packageInfo = await PackageInfo.fromPlatform();

    if (_repository.isLogIn) {
      _loginStatus = _LoginStatus.loggedIn;
    } else {
      _loginStatus = _LoginStatus.notLogin;
    }

    loadSuccess();
  }

  String getLoginUserName() {
    if (loggedIn) {
      return _repository.userName ?? AppStrings.settingsLoginNameNotSettingLabel;
    } else {
      return AppStrings.settingsNotLoginNameLabel;
    }
  }

  String getLoginEmail() {
    if (loggedIn) {
      return _repository.userEmail ?? AppStrings.settingsLoginEmailNotSettingLabel;
    } else {
      return AppStrings.settingsNotLoginEmailLabel;
    }
  }

  Future<void> loginWithGoogle() async {
    nowLoading();
    await _repository.login();
    _loginStatus = _LoginStatus.loggedIn;
    loadSuccess();
  }

  Future<bool> logout() async {
    try {
      await _repository.logout();
      _loginStatus = _LoginStatus.notLogin;
      notifyListeners();
      return true;
    } catch (e, s) {
      await AppLogger.e('ログアウトに失敗しました。', e, s);
      return false;
    }
  }
}

enum _LoginStatus { notLogin, loggedIn }
