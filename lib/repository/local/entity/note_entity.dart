import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/entity/db_entity.dart';

class NoteEntity extends DBEntity {
  const NoteEntity({
    required this.id,
    required this.title,
    required this.typeValue,
    required this.detail,
  });

  static const tableName = 'Note';
  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT,
      $columnTypeValue INTEGER,
      $columnDetail TEXT
    )
  ''';

  static const String columnId = 'id';
  final int id;

  static const String columnTitle = 'title';
  final String title;

  static const String columnTypeValue = 'typeValue';
  final int typeValue;

  static const String columnDetail = 'detail';
  final String detail;

  static NoteEntity fromMap(Map<String, dynamic> map) {
    return NoteEntity(
      id: map[columnId] as int,
      typeValue: map[columnTypeValue] as int,
      title: map[columnTitle] as String,
      detail: map[columnDetail] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{columnId: id, columnTypeValue: typeValue, columnTitle: title, columnDetail: detail};
  }
}

extension NoteMapper on Note {
  NoteEntity toEntity() {
    return NoteEntity(id: id, title: title, typeValue: typeValue, detail: detail);
  }
}

extension NoteEntityMapper on NoteEntity {
  Note toNote() {
    return Note(id: id, typeValue: typeValue, title: title, detail: detail);
  }
}
