import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/base_view_model.dart';

final notesViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _NotesViewModel(ref.read));

class _NotesViewModel extends BaseViewModel {
  _NotesViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    try {
      await _read(notesProvider.notifier).onLoad();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('ノート一覧の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> reload() async {
    await _read(notesProvider.notifier).onLoad();
  }
}
