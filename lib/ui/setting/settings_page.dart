import 'package:dyphic/ui/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/setting/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.settingsPageTitle)),
      body: ChangeNotifierProvider<SettingsViewModel>(
        create: (_) => SettingsViewModel.create(),
        builder: (context, _) {
          final pageState = context.select<SettingsViewModel, PageLoadingState>((vm) => vm.pageState);
          if (pageState.isLoadSuccess) {
            return _loadSuccessView(context);
          } else {
            return _nowLoadingView();
          }
        },
        child: _nowLoadingView(),
      ),
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return ListView(
      children: [
        _rowAppVersion(context),
        _rowThemeModeSwitch(context),
        DividerThemeColor.create(),
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
