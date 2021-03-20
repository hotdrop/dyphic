import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/remote/note_api.dart';

class NoteRepository {
  const NoteRepository._(this._api);

  factory NoteRepository.create() {
    return NoteRepository._(NoteApi.create());
  }

  final NoteApi _api;

  Future<List<Note>> findAll() async {
    final notes = await _api.findAll();
    AppLogger.d('ノートを取得しました。データ数: ${notes.length}');
    return notes;
  }

  Future<void> save(Note note) async {
    AppLogger.d('ノート情報を保存します。');
    await _api.save(note);
  }
}
