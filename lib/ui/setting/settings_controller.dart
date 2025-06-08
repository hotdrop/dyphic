import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/note_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/repository/account_repository.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final name = ref.read(accountRepositoryProvider).userName ?? 'ー';
    final email = ref.read(accountRepositoryProvider).userEmail ?? '未ログイン';

    ref.read(settingUiStateProvider.notifier).update((uiState) => _UiState(
          isSignIn: ref.read(accountRepositoryProvider).isSignIn,
          userName: name,
          email: email,
          appVersion: '${packageInfo.version}-${packageInfo.buildNumber}',
        ));
  }

  ///
  /// サインイン情報
  ///
  Future<void> signIn() async {
    try {
      await ref.read(accountRepositoryProvider).signIn();
    } catch (e, s) {
      await AppLogger.e('サインインに失敗しました。', e, s);
      ref.read(settingUiStateProvider.notifier).update((uiState) => uiState.copyWith(
            errorMessage: 'サインインに失敗しました。$e',
          ));
    }
  }

  Future<void> signOut() async {
    await ref.read(accountRepositoryProvider).signOut();
  }

  Future<void> onLoadRecord() async {
    try {
      await ref.read(recordRepositoryProvider).onLoadLatest();
    } catch (e, s) {
      await AppLogger.e('記録情報の取得に失敗しました。', e, s);
      ref.read(settingUiStateProvider.notifier).update((uiState) => uiState.copyWith(
            errorMessage: '記録情報の取得に失敗しました。$e',
          ));
    }
  }

  Future<void> onLoadLatestData() async {
    try {
      // お薬、体調、ノートの全データを更新する
      await ref.read(medicineRepositoryProvider).onLoadLatest();
      await ref.read(conditionRepositoryProvider).onLoadLatest();
      await ref.read(noteRepositoryProvider).onLoadLatest();
    } catch (e, s) {
      await AppLogger.e('お薬、体調、ノートの各情報の取得に失敗しました。', e, s);
      rethrow;
    }
  }
}

final settingUiStateProvider = StateProvider((_) => _UiState.create());

///
/// 入力保持用のクラス
///
class _UiState {
  const _UiState({
    required this.isSignIn,
    required this.userName,
    required this.email,
    required this.appVersion,
    this.errorMessage = '',
  });

  factory _UiState.create() {
    return const _UiState(
      isSignIn: false,
      userName: 'ー',
      email: '未ログイン',
      appVersion: '',
      errorMessage: '',
    );
  }

  final bool isSignIn;
  final String userName;
  final String email;
  final String appVersion;
  final String errorMessage;

  _UiState copyWith({
    bool? isSignIn,
    String? userName,
    String? email,
    String? appVersion,
    String? errorMessage,
  }) {
    return _UiState(
      isSignIn: isSignIn ?? this.isSignIn,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      appVersion: appVersion ?? this.appVersion,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
