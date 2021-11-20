import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteApiProvider = Provider((ref) => _NoteApi(ref.read));

class _NoteApi {
  const _NoteApi(this._read);

  final Reader _read;

  Future<List<Note>> findAll() async {
    AppLogger.d('サーバーからノート情報を全取得します。');
    return await _read(appFirebaseProvider).findNotes();
  }

  Future<void> save(Note note) async {
    AppLogger.d('サーバーにノート情報を保存します。');
    await _read(appFirebaseProvider).saveNote(note);
  }
}
