import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/note_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class NoteEditViewModel extends NotifierViewModel {
  NoteEditViewModel._(this._originalNote, this._repository) {
    _init();
  }

  factory NoteEditViewModel.create(Note note) {
    return NoteEditViewModel._(note, NoteRepository.create());
  }

  final NoteRepository _repository;
  final Note _originalNote;

  late String _inputTitle;
  late String _inputDetail;
  late int _inputTypeValue;
  int get inputTypeValue => _inputTypeValue;

  bool get canSave => _inputTitle.isNotEmpty;

  void _init() {
    _inputTitle = _originalNote.title;
    _inputDetail = _originalNote.detail;
    _inputTypeValue = _originalNote.typeValue;
    loadSuccess();
  }

  void inputType(int type) {
    AppLogger.d('選択した値 $type を保存します。');
    _inputTypeValue = type;
    notifyListeners();
  }

  void inputTitle(String title) {
    _inputTitle = title;
  }

  void inputDetail(String detail) {
    _inputDetail = detail;
  }

  Future<bool> save() async {
    final newNote = Note(id: _originalNote.id, typeValue: _inputTypeValue, title: _inputTitle, detail: _inputDetail);
    try {
      await _repository.save(newNote);
      return true;
    } catch (e, s) {
      await AppLogger.e('ノートの保存に失敗しました。', e, s);
      return false;
    }
  }
}
