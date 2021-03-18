import 'dart:math';

import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/note_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class NotesViewModel extends NotifierViewModel {
  NotesViewModel._(this._repository) {
    _init();
  }

  factory NotesViewModel.create() {
    return NotesViewModel._(NoteRepository.create());
  }

  final NoteRepository _repository;

  late List<Note> _notes;
  List<Note> get notes => _notes;

  Future<void> _init() async {
    _notes = await _repository.findAll();
    loadSuccess();
  }

  int createNewId() {
    if (_notes.isNotEmpty) {
      return _notes.map((e) => e.id).reduce(max) + 1;
    } else {
      return 1;
    }
  }

  Future<void> reload() async {
    nowLoading();
    _notes = await _repository.findAll();
    loadSuccess();
  }
}
