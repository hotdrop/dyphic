import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/service/firestore.dart';

final noteApiProvider = Provider((ref) => _NoteApi(ref));

class _NoteApi {
  const _NoteApi(this._ref);

  final Ref _ref;

  Future<List<Note>> findAll() async {
    AppLogger.d('サーバーからノート情報を全取得します。');
    return await _ref.read(firestoreProvider).findNotes();
  }

  Future<void> save(Note note) async {
    AppLogger.d('サーバーにノート情報を保存します。');
    await _ref.read(firestoreProvider).saveNote(note);
  }
}
