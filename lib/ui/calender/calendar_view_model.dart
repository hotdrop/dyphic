import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    try {
      await _read(recordsProvider.notifier).onLoad();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('カレンダー情報の取得に失敗しました。', e, s);
      onError('$e');
    }
  }
}
