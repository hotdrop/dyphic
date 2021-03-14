import 'package:dyphic/model/calendar_event.dart';

class EventEntity {
  const EventEntity(this.id, this.type, this.name);

  EventEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        type = map[columnType] as int,
        name = map[columnName] as String;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{columnId: id, columnType: type, columnName: name};
  }

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
}

extension EventMapper on Event {
  EventEntity toEntity() {
    return EventEntity(id, type.index, name);
  }
}

extension EventEntityMapper on EventEntity {
  Event toEvent() {
    final type = Event.toType(this.type);
    return Event(id: id, type: type, name: name);
  }
}
