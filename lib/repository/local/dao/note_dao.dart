import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/entity/note_entity.dart';
import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:isar/isar.dart';

final noteDaoProvider = Provider((ref) => _NoteDao(ref));

class _NoteDao {
  const _NoteDao(this._ref);

  final Ref _ref;

  Future<Note?> find(int id) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final note = await isar.noteEntitys.get(id);
    if (note == null) {
      return null;
    }
    return _toNote(note);
  }

  Future<List<Note>> findAll() async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final notes = await isar.noteEntitys.where().findAll();
    return notes.map((m) => _toNote(m)).toList();
  }

  Future<void> save(Note note) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _toEntity(note);
      await isar.noteEntitys.put(entity);
    });
  }

  Future<void> saveAll(List<Note> notes) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = notes.map((c) => _toEntity(c)).toList();
      await isar.noteEntitys.clear();
      await isar.noteEntitys.putAll(entities);
    });
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
