import 'dart:math';

import 'package:dyphic/repository/note_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider = StateNotifierProvider<_NoteNotifier, List<Note>>((ref) => _NoteNotifier(ref.read));

class _NoteNotifier extends StateNotifier<List<Note>> {
  _NoteNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> onLoad() async {
    state = await _read(noteRepositoryProvider).findAll(isForceUpdate: false);
  }

  Future<void> refresh() async {
    state = await _read(noteRepositoryProvider).findAll(isForceUpdate: true);
  }

  Future<void> save(Note newNote) async {
    await _read(noteRepositoryProvider).save(newNote);
    await onLoad();
  }

  Note newNote() {
    final newId = _createNewId();
    return Note.createEmpty(newId);
  }

  int _createNewId() {
    return (state.isNotEmpty) ? state.map((e) => e.id).reduce(max) + 1 : 1;
  }
}

class Note {
  const Note({
    required this.id,
    required this.typeValue,
    required this.title,
    required this.detail,
  });

  factory Note.createEmpty(int id) {
    return Note(id: id, typeValue: 1, title: '', detail: '');
  }

  final int id;
  final int typeValue;
  final String title;
  final String detail;
}

class NoteType {
  const NoteType(this.typeValue, this.iconData, this.color);

  factory NoteType.fromValue(int typeValue) {
    return values.firstWhere(
      (e) => e.typeValue == typeValue,
      orElse: () => NoteType(1, Icons.lunch_dining, Colors.orange[300]),
    );
  }

  final int typeValue;
  final IconData iconData;
  final Color? color;

  static List<NoteType> get values => [
        NoteType(1, Icons.lunch_dining, Colors.orange[300]),
        NoteType(2, Icons.local_hospital_outlined, Colors.blue[300]),
        NoteType(3, Icons.sick_outlined, Colors.purple[300]),
        NoteType(4, Icons.sticky_note_2_outlined, Colors.green[300]),
        NoteType(5, Icons.do_not_disturb, Colors.red[300]),
      ];
}
