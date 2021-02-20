import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:dyphic/model/page_state.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel._();

  factory SettingsViewModel.create() {
    return SettingsViewModel._();
  }

  PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  PageState pageState = PageNowLoading();

  Future<void> init() async {
    _nowLoading();
    _packageInfo = await PackageInfo.fromPlatform();
    _loadSuccess();
  }

  void _nowLoading() {
    pageState = PageNowLoading();
    notifyListeners();
  }

  void _loadSuccess() {
    pageState = PageLoaded();
    notifyListeners();
  }
}
