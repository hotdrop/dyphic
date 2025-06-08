import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/ui/setting/settings_controller.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ref.watch(settingsControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, stackTrace) {
              return Center(
                child: Text('$err', style: const TextStyle(color: Colors.red)),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(settingUiStateProvider).isSignIn;
    return ListView(
      children: [
        const _ViewAccountInfo(),
        if (!signIn)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '※Googleアカウントでログインできます。ログインすると各データの登録/編集が可能になります。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const _ViewAppLicense(),
        const Divider(),
        const _ViewOnRefreshRecord(),
        const _ViewOnRefreshData(),
      ],
    );
  }
}

class _ViewAccountInfo extends ConsumerWidget {
  const _ViewAccountInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(settingUiStateProvider);

    return ListTile(
      leading: const Icon(Icons.account_circle, size: 30),
      title: Text(uiState.userName),
      subtitle: Text(uiState.email),
      trailing: (uiState.isSignIn) ? const _ViewSignOutButton() : const _ViewSignInButton(),
    );
  }
}

class _ViewSignInButton extends ConsumerWidget {
  const _ViewSignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(settingsControllerProvider.notifier).signIn(),
      child: const Text('ログイン'),
    );
  }
}

class _ViewSignOutButton extends ConsumerWidget {
  const _ViewSignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(settingsControllerProvider.notifier).signOut,
          onSuccess: (_) {/* 成功時は何もしない */},
          onError: (err) async => await AppDialog.onlyOk(message: err).show(context),
        );
      },
      child: const Text('ログアウト'),
    );
  }
}

class _ViewAppLicense extends ConsumerWidget {
  const _ViewAppLicense();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.info_outline, size: 30),
      title: const Text('ライセンス'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: '体調管理',
          applicationVersion: ref.watch(settingUiStateProvider).appVersion,
          applicationIcon: Image.asset(AppImages.icLaunch, width: 50, height: 50),
        );
      },
    );
  }
}

class _ViewOnRefreshRecord extends ConsumerWidget {
  const _ViewOnRefreshRecord();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.calendar_month_outlined, size: 30),
      title: const Text('記録情報の更新'),
      subtitle: const Text('日々の記録情報を最新データを取得'),
      onTap: () async => await _showLoadRecordDialog(context, ref),
    );
  }

  Future<void> _showLoadRecordDialog(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: 'サーバーから最新の記録情報を取得します。\nよろしいですか？\n\n※注意！\nこの操作は通常行う必要はありません。他の人がデータを更新した場合に実行してください。',
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(settingsControllerProvider.notifier).onLoadRecord,
          onSuccess: (_) => {/* 成功時は何もしない */},
          onError: (err) => AppDialog.onlyOk(message: err).show(context),
        );
      },
    ).show(context);
  }
}

class _ViewOnRefreshData extends ConsumerWidget {
  const _ViewOnRefreshData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.download, size: 30),
      title: const Text('各種データ更新'),
      subtitle: const Text('お薬、体調、ノートの最新データ取得'),
      onTap: () async => await _showRefreshDialog(context, ref),
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    AppDialog.okAndCancel(
      message: 'サーバーから最新のお薬、体調、ノート情報を取得します。\nよろしいですか？',
      onOk: () async => await _refresh(context, ref),
    ).show(context);
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(settingsControllerProvider.notifier).onLoadLatestData,
      onSuccess: (_) => {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
