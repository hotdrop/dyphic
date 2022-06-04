import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/condition/condition_page.dart';
import 'package:dyphic/ui/medicine/medicine_page.dart';
import 'package:dyphic/ui/setting/settings_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const double _iconSize = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(settingsViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsPageTitle),
      ),
      body: uiState.when(
        loading: (errMsg) => _onLoading(context, errMsg),
        success: () => _onSuccess(context, ref),
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(appSettingsProvider).isSignIn;
    return ListView(
      children: [
        _rowAccountInfo(context, ref),
        if (!signIn) _viewSignInLabel(context),
        _rowAppLicense(context, ref),
        _rowSwitchTheme(context, ref),
        const Divider(),
        _rowConditionEdit(context),
        _rowMedicineEdit(context),
        const Divider(),
        _rowLoadRecord(context, ref),
        _rowLoadNote(context, ref),
      ],
    );
  }

  Widget _rowAccountInfo(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return ListTile(
      leading: const Icon(Icons.account_circle, size: _iconSize),
      title: Text(ref.watch(settingsViewModelProvider).userName),
      subtitle: Text(ref.watch(settingsViewModelProvider).email),
      trailing: (isSignIn) ? _buttonSignOut(context, ref) : _buttonSignIn(ref),
    );
  }

  Widget _rowAppLicense(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(LineIcons.infoCircle, size: _iconSize),
      title: const Text(AppStrings.settingsLicenseLabel),
      trailing: const Icon(LineIcons.angleRight),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: AppStrings.appTitle,
          applicationVersion: ref.watch(settingsViewModelProvider).appVersion,
          applicationIcon: Image.asset(AppImages.icLaunch, width: 50, height: 50),
        );
      },
    );
  }

  Widget _rowSwitchTheme(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return ListTile(
      leading: AppIcon.changeTheme(isDarkMode, size: _iconSize),
      title: const Text(AppStrings.settingsChangeAppThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => ref.read(appSettingsProvider.notifier).changeTheme(isDark),
        value: isDarkMode,
      ),
    );
  }

  Widget _rowConditionEdit(BuildContext context) {
    return ListTile(
      leading: AppIcon.condition(size: _iconSize),
      title: const Text(AppStrings.settingsEditConditionLabel),
      subtitle: const Text(AppStrings.settingsEditConditionSubLabel),
      onTap: () async => await ConditionPage.start(context),
    );
  }

  Widget _rowMedicineEdit(BuildContext context) {
    return ListTile(
      leading: AppIcon.medicine(size: _iconSize),
      title: const Text(AppStrings.settingsEditMedicineLabel),
      subtitle: const Text(AppStrings.settingsEditMedicineSubLabel),
      onTap: () async => await MedicinePage.start(context),
    );
  }

  Widget _rowLoadRecord(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AppIcon.record(size: _iconSize),
      title: const Text(AppStrings.settingsLoadRecordLabel),
      subtitle: const Text(AppStrings.settingsLoadRecordSubLabel),
      onTap: () async => await _showLoadRecordDialog(context, ref),
    );
  }

  Future<void> _showLoadRecordDialog(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: AppStrings.settingsLoadRecordConfirmMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(settingsViewModelProvider).onLoadRecord,
          onSuccess: (_) => {/* 成功時は何もしない */},
          onError: (err) => AppDialog.onlyOk(message: err).show(context),
        );
      },
    ).show(context);
  }

  Widget _rowLoadNote(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AppIcon.note(size: _iconSize),
      title: const Text(AppStrings.settingsLoadNoteLabel),
      subtitle: const Text(AppStrings.settingsLoadNoteSubLabel),
      onTap: () async => await _showLoadNoteDialog(context, ref),
    );
  }

  Future<void> _showLoadNoteDialog(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: AppStrings.settingsLoadNoteConfirmMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(settingsViewModelProvider).onLoadNote,
          onSuccess: (_) => {/* 成功時は何もしない */},
          onError: (err) => AppDialog.onlyOk(message: err).show(context),
        );
      },
    ).show(context);
  }

  Widget _buttonSignIn(WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(settingsViewModelProvider).signIn(),
      child: const Text(AppStrings.settingsLoginWithGoogle),
    );
  }

  Widget _viewSignInLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(AppStrings.settingsLoginInfo, style: Theme.of(context).textTheme.caption),
    );
  }

  Widget _buttonSignOut(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(settingsViewModelProvider).signOut,
          onSuccess: (_) {/* 成功時は何もしない */},
          onError: (err) async => await AppDialog.onlyOk(message: err).show(context),
        );
      },
      child: const Text(AppStrings.settingsLogoutLabel),
    );
  }
}
