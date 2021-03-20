import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/db_provider.dart';
import 'package:dyphic/repository/local/entity/note_entity.dart';

///
/// このクラス使わない
///
class NoteDataSource {
  const NoteDataSource._(this._dbProvider);

  factory NoteDataSource.create() {
    return NoteDataSource._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Note>> findAll() async {
    final List<NoteEntity> entities = await _dbProvider.findAll(NoteEntity.tableName, NoteEntity.fromMap);
    return entities.map((e) => e.toNote()).toList();
  }

  Future<void> saveAll(List<Note> notes) async {
    final entities = notes.map((e) => e.toEntity()).toList();
    await _dbProvider.updateAll(NoteEntity.tableName, entities);
  }

  Future<void> save(Note note) async {
    final entity = note.toEntity();
    await _dbProvider.insert(NoteEntity.tableName, entity);
  }
}
