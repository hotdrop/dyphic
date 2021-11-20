import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/dao/note_dao.dart';
import 'package:dyphic/repository/remote/note_api.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref.read));

class _NoteRepository {
  const _NoteRepository(this._read);

  final Reader _read;

  ///
  /// ノート情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Note>> findAll({required bool isForceUpdate}) async {
    final notes = await _read(noteDaoProvider).findAll();
    if (notes.isNotEmpty && !isForceUpdate) {
      return notes;
    }

    // API経由でデータ取得
    final newNotes = await _read(noteApiProvider).findAll();
    await _read(noteDaoProvider).saveAll(newNotes);
    return newNotes;
  }

  Future<void> save(Note note) async {
    await _read(noteApiProvider).save(note);
    await _read(noteDaoProvider).save(note);
  }
}
