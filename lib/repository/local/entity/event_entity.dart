import 'package:dalico/model/calendar_event.dart';

class EventEntity {
  EventEntity(this.year, this.month, this.day, this.type, this.name);

  EventEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        year = map[columnYear] as int,
        month = map[columnMonth] as int,
        day = map[columnDay] as int,
        type = map[columnType] as int,
        name = map[columnName] as String;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{columnYear: year, columnMonth: month, columnDay: day, columnType: type, columnName: name};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  static const String tableName = 'Event';
  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY autoincrement,
      $columnYear INTEGER,
      $columnMonth INTEGER,
      $columnDay INTEGER,
      $columnType INTEGER,
      $columnName TEXT
    )
  ''';

  static const String columnId = 'id';
  int id;

  static const String columnYear = 'year';
  final int year;

  static const String columnMonth = 'month';
  final int month;

  static const String columnDay = 'day';
  final int day;

  static const String columnType = 'type';
  final int type;

  static const String columnName = 'name';
  final String name;
}

extension EventMapper on Event {
  EventEntity toEntity() {
    return EventEntity(this.date.year, this.date.month, this.date.day, this.type.index, this.name);
  }
}

extension EventEntityMapper on EventEntity {
  Event toEvent() {
    final date = DateTime(this.year, this.month, this.day);
    final type = Event.toType(this.type);
    return Event(date: date, type: type, name: this.name);
  }
}
