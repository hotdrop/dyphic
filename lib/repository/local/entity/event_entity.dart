import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/entity/db_entity.dart';

class EventEntity extends DBEntity {
  const EventEntity({
    required this.id,
    required this.type,
    required this.name,
  });

  static const String tableName = 'Event';
  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnType INTEGER,
      $columnName TEXT
    )
  ''';

  static const String columnId = 'id';
  final int id;

  static const String columnType = 'type';
  final int type;

  static const String columnName = 'name';
  final String name;

  static EventEntity fromMap(Map<String, dynamic> map) {
    return EventEntity(
      id: map[columnId] as int,
      type: map[columnType] as int,
      name: map[columnName] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{columnId: id, columnType: type, columnName: name};
  }
}

extension EventMapper on Event {
  EventEntity toEntity() {
    return EventEntity(id: id, type: type.index, name: name);
  }
}

extension EventEntityMapper on EventEntity {
  Event toEvent() {
    final type = Event.toType(this.type);
    return Event(id: id, type: type, name: name);
  }
}
