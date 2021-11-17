import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';

final settingsViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SettingsViewModel(ref.read));

class _SettingsViewModel extends BaseViewModel {
  _SettingsViewModel(this._read) {
    _init();
  }

  final Reader _read;

  // アプリ情報
  late PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  // サインイン情報
  bool get isSignIn => _read(accountRepositoryProvider).isSignIn;
  String get userName => _read(accountRepositoryProvider).userName ?? AppStrings.settingsNotSignInNameLabel;
  String get email => _read(accountRepositoryProvider).userEmail ?? AppStrings.settingsNotSignInEmailLabel;

  Future<void> _init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('設定画面の初期化に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> signIn() async {
    await _read(accountRepositoryProvider).signIn();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _read(accountRepositoryProvider).signOut();
    notifyListeners();
  }
}
