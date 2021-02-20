import 'package:dyphic/ui/notifier_view_model.dart';
import 'package:package_info/package_info.dart';

class SettingsViewModel extends NotifierViewModel {
  SettingsViewModel._();

  factory SettingsViewModel.create() {
    return SettingsViewModel._();
  }

  PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    loadSuccess();
  }
}
