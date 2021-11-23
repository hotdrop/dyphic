import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _NoteEditViewModel(ref.read));

class _NoteEditViewModel extends BaseViewModel {
  _NoteEditViewModel(this._read);

  final Reader _read;

  late Note _originalNote;

  late String _inputTitle;
  late String _inputDetail;
  late int _inputTypeValue;

  bool get canSaved => ((_inputTitle.isNotEmpty && _read(appSettingsProvider).isSignIn));

  void init(Note note) {
    _originalNote = note;
    _inputTitle = note.title;
    _inputDetail = note.detail;
    _inputTypeValue = note.typeValue;
    onSuccess();
  }

  void inputType(int type) {
    _inputTypeValue = type;
  }

  void inputTitle(String title) {
    _inputTitle = title;
    notifyListeners();
  }

  void inputDetail(String detail) {
    _inputDetail = detail;
  }

  Future<void> save() async {
    final newNote = Note(
      id: _originalNote.id,
      typeValue: _inputTypeValue,
      title: _inputTitle,
      detail: _inputDetail,
    );
    try {
      await _read(notesProvider.notifier).save(newNote);
    } catch (e, s) {
      await AppLogger.e('ノートの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}
