import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/condition/condition_page.dart';
import 'package:dyphic/ui/medicine/medicine_page.dart';
import 'package:dyphic/ui/setting/settings_view_model.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.settingsPageTitle),
      ),
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
      child: const CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final loggedIn = context.select<SettingsViewModel, bool>((vm) => vm.loggedIn);
    return ListView(
      children: [
        _rowAccountInfo(context),
        if (!loggedIn) _loginDescriptionLabel(context),
        const Divider(),
        _rowConditionEdit(context),
        _rowMedicineEdit(context),
        _rowSwitchTheme(context),
        const Divider(),
        _rowAppVersion(context),
      ],
    );
  }

  Widget _rowAccountInfo(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    final loggedIn = context.select<SettingsViewModel, bool>((vm) => vm.loggedIn);
    return ListTile(
      leading: Icon(Icons.account_circle, size: _iconSize),
      title: Text(viewModel.getLoginEmail(), style: TextStyle(fontSize: 12.0)),
      subtitle: Text(viewModel.getLoginUserName()),
      trailing: (loggedIn) ? _logoutButton(context) : _loginButton(context),
    );
  }

  Widget _rowConditionEdit(BuildContext context) {
    final isDarkMode = Provider.of<AppSettings>(context).isDarkMode;
    return ListTile(
      leading: AppIcon.condition(isDarkMode, size: _iconSize),
      title: const Text(AppStrings.settingsEditConditionLabel),
      subtitle: const Text(AppStrings.settingsEditConditionSubLabel),
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => ConditionPage()),
        );
      },
    );
  }

  Widget _rowMedicineEdit(BuildContext context) {
    final isDarkMode = Provider.of<AppSettings>(context).isDarkMode;
    return ListTile(
      leading: AppIcon.medicine(isDarkMode, size: _iconSize),
      title: const Text(AppStrings.settingsEditMedicineLabel),
      subtitle: const Text(AppStrings.settingsEditMedicineSubLabel),
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => MedicinePage()),
        );
      },
    );
  }

  Widget _rowSwitchTheme(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return ListTile(
      leading: AppIcon.changeTheme(appSettings.isDarkMode, size: _iconSize),
      title: const Text(AppStrings.settingsChangeAppThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => appSettings.changeTheme(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.select<SettingsViewModel, String>((vm) => vm.appVersion);
    return ListTile(
      leading: Icon(Icons.info, size: _iconSize),
      title: const Text(AppStrings.settingsAppVersionLabel),
      trailing: Text(appVersion),
    );
  }

  Widget _loginButton(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return ElevatedButton(
      onPressed: () => viewModel.loginWithGoogle(),
      child: const Text(AppStrings.settingsLoginWithGoogle),
    );
  }

  Widget _loginDescriptionLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(AppStrings.settingsLoginInfo, style: Theme.of(context).textTheme.caption),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return OutlinedButton(
      onPressed: () async {
        await AppProgressDialog(execute: viewModel.logout).show(context);
        Navigator.pop(context);
      },
      child: Text(AppStrings.settingsLogoutLabel),
    );
  }
}
