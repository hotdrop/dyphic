import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/repository/note_repository.dart';
import 'package:dyphic/model/note.dart';

part 'notes_controller.g.dart';

@riverpod
class NotesController extends _$NotesController {
  @override
  Future<void> build() async {
    await onLoad();
  }

  Future<void> onLoad() async {
    final notes = await ref.read(noteRepositoryProvider).findAll();
    ref.read(notesUiStateProvider.notifier).state = notes;
  }

  Future<void> refresh() async {
    final notes = await ref.read(noteRepositoryProvider).findAll(isLoadLatest: true);
    ref.read(notesUiStateProvider.notifier).state = notes;
  }

  int createNewId() {
    final notes = ref.read(notesUiStateProvider);
    return (notes.isNotEmpty) ? notes.map((e) => e.id).reduce(max) + 1 : 1;
  }
}

final notesUiStateProvider = StateProvider<List<Note>>((_) => []);
