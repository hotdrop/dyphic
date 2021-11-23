import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/event_repository.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  // 前回イベント情報取得日の文字列表現
  late String _prevLoadEventStr;
  String get prevLoadEventStr => _prevLoadEventStr;

  // サインイン情報
  String get userName => _read(accountRepositoryProvider).userName ?? AppStrings.settingsNotSignInNameLabel;
  String get email => _read(accountRepositoryProvider).userEmail ?? AppStrings.settingsNotSignInEmailLabel;

  Future<void> _init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      final prevDate = await _read(eventRepositoryProvider).getPreviousLoadEventDate();
      _prevLoadEventStr = (prevDate == null) ? 'ー' : DateFormat('yyyy年MM月dd日').format(prevDate);
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('設定画面の初期化に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> signIn() async {
    try {
      await _read(accountRepositoryProvider).signIn();
      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('サインインに失敗しました。', e, s);
      onError('サインインに失敗しました。$e');
    }
  }

  Future<void> signOut() async {
    await _read(accountRepositoryProvider).signOut();
    notifyListeners();
  }

  Future<void> onLoadEvent() async {
    try {
      await _read(eventRepositoryProvider).refresh();
      await _read(recordsProvider.notifier).onLoad();
    } catch (e, s) {
      await AppLogger.e('イベント情報の取得に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> onLoadRecord() async {
    try {
      await _read(recordsProvider.notifier).refresh();
    } catch (e, s) {
      await AppLogger.e('記録情報の取得に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> onLoadNote() async {
    try {
      await _read(notesProvider.notifier).refresh();
    } catch (e, s) {
      await AppLogger.e('ノート情報の取得に失敗しました。', e, s);
      rethrow;
    }
  }

  void refresh() {
    notifyListeners();
  }
}
