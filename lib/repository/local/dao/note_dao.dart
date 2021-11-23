import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/entity/note_entity.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteDaoProvider = Provider((ref) => const _NoteDao());

class _NoteDao {
  const _NoteDao();

  Future<List<Note>> findAll() async {
    final box = await Hive.openBox<NoteEntity>(NoteEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    return box.values.map((m) => _toNote(m)).toList();
  }

  Future<void> saveAll(List<Note> notes) async {
    final box = await Hive.openBox<NoteEntity>(NoteEntity.boxName);
    final entities = notes.map((c) => _toEntity(c)).toList();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  Future<void> save(Note note) async {
    final box = await Hive.openBox<NoteEntity>(NoteEntity.boxName);
    final entity = _toEntity(note);
    await box.put(entity.id, entity);
  }

  Note _toNote(NoteEntity entity) {
    return Note(
      id: entity.id,
      typeValue: entity.typeValue,
      title: entity.title,
      detail: entity.detail,
    );
  }

  NoteEntity _toEntity(Note n) {
    return NoteEntity(
      id: n.id,
      title: n.title,
      typeValue: n.typeValue,
      detail: n.detail,
    );
  }
}
