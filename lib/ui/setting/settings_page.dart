import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/page_state.dart';
import 'package:dalico/ui/setting/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel.create()..init(),
      builder: (context, _) {
        final pageState = context.select<SettingsViewModel, PageState>((vm) => vm.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else {
          return _loadView(context);
        }
      },
      child: _loadingView(),
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.settingsPageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.settingsPageTitle)),
      body: Center(
        child: _contentsView(context),
      ),
    );
  }

  Widget _contentsView(BuildContext context) {
    return ListView(
      children: [
        _rowAppVersion(context),
        _rowThemeModeSwitch(context),
        Divider(color: Theme.of(context).accentColor),
      ],
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.select<SettingsViewModel, String>((vm) => vm.appVersion);
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text(AppStrings.settingsAppVersionLabel),
      trailing: Text(appVersion),
    );
  }

  Widget _rowThemeModeSwitch(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return ListTile(
      leading: Icon(appSettings.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
      title: const Text(AppStrings.settingsChangeAppThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => appSettings.changeTheme(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }
}
