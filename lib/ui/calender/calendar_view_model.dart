import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;

  bool _isEditRecord = false;
  bool get isEditRecord => _isEditRecord;

  Future<void> _init() async {
    try {
      await _read(recordsProvider.notifier).onLoad();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('カレンダー情報の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  /// 記録詳細ページで何か編集したらこれをtrueにする。trueだったらカレンダーを更新する。
  /// 記録詳細ページはPageViewで実装しているので、各々のページで更新情報を持つと別のページ切り替え時にその情報が消えてしまう
  /// 消えないように記録詳細ページ全体のStateを作るかベースとなるこのViewModelで持つか迷った結果、一旦ここで持つことにした。
  void markRecordEditted() {
    _isEditRecord = true;
  }
}
