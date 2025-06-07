import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/dao/note_dao.dart';
import 'package:dyphic/repository/remote/note_api.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref));

class _NoteRepository {
  const _NoteRepository(this._ref);

  final Ref _ref;

  ///
  /// ノート情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Note>> findAll({required bool isForceUpdate}) async {
    final notes = await _ref.read(noteDaoProvider).findAll();
    if (notes.isNotEmpty && !isForceUpdate) {
      return notes;
    }

    final newNotes = await _ref.read(noteApiProvider).findAll();
    await _ref.read(noteDaoProvider).saveAll(newNotes);
    return newNotes;
  }

  Future<void> save(Note newNote) async {
    await _ref.read(noteApiProvider).save(newNote);
    await _ref.read(noteDaoProvider).save(newNote);
  }
}
