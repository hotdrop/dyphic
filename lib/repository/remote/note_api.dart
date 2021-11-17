import 'package:dyphic/model/note.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteApiProvider = Provider((ref) => _NoteApi(ref.read));

class _NoteApi {
  const _NoteApi(this._read);

  final Reader _read;

  Future<List<Note>> findAll() async {
    return await _read(appFirebaseProvider).findNotes();
  }

  Future<void> save(Note note) async {
    await _read(appFirebaseProvider).saveNote(note);
  }
}
