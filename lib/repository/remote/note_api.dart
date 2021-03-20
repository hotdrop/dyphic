import 'package:dyphic/model/note.dart';
import 'package:dyphic/service/app_firebase.dart';

class NoteApi {
  const NoteApi._(this._appFirebase);

  factory NoteApi.create() {
    return NoteApi._(AppFirebase.instance);
  }

  final AppFirebase _appFirebase;

  Future<List<Note>> findAll() async {
    return await _appFirebase.findNotes();
  }

  Future<void> save(Note note) async {
    await _appFirebase.saveNote(note);
  }
}
