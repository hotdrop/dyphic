import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/remote/note_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref.read));

class _NoteRepository {
  const _NoteRepository(this._read);

  final Reader _read;

  Future<List<Note>> findAll() async {
    final notes = await _read(noteApiProvider).findAll();
    AppLogger.d('ノートを取得しました。データ数: ${notes.length}');
    return notes;
  }

  Future<void> save(Note note) async {
    AppLogger.d('ノート情報を保存します。');
    await _read(noteApiProvider).save(note);
  }
}
