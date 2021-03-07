import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_divider.dart';
import 'package:dyphic/ui/widget/app_outline_button.dart';
import 'package:dyphic/ui/widget/app_text.dart';
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
    final loggedIn = context.select<SettingsViewModel, bool>((vm) => vm.loggedIn);
    return ListView(
      children: [
        _rowAppVersion(context),
        _rowThemeModeSwitch(context),
        DividerThemeColor.create(),
        _rowAccountInfo(context),
        DividerThemeColor.create(),
        _loginDescriptionLabel(),
        if (loggedIn) _logoutButton(context),
        if (!loggedIn) _loginButton(context),
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
        activeColor: Theme.of(context).primaryColor,
        onChanged: (isDark) => appSettings.changeTheme(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }

  Widget _rowAccountInfo(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 40.0),
      title: Text(viewModel.getLoginEmail()),
      subtitle: Text(viewModel.getLoginUserName()),
    );
  }

  Widget _loginDescriptionLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: AppText.normal(text: AppStrings.settingsLoginInfo),
    );
  }

  Widget _loginButton(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: RaisedButton(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Text(AppStrings.settingsLoginWithGoogle, style: TextStyle(color: Colors.white)),
        onPressed: () {
          viewModel.loginWithGoogle();
        },
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: AppOutlineButton(
        label: AppStrings.settingsLogoutTitle,
        isCircular: true,
        onPressed: () async {
          final dialog = AppDialog.createInfo(
            title: AppStrings.settingsLogoutTitle,
            description: AppStrings.settingsLogoutDialogMessage,
            successMessage: AppStrings.settingsLogoutSuccessMessage,
            errorMessage: AppStrings.settingsEditDialogError,
            onOkPress: viewModel.logout,
          );
          await dialog.show(context);
        },
      ),
    );
  }
}
