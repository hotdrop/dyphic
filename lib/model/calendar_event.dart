import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/record.dart';

class CalendarEvent {
  const CalendarEvent._({
    required this.id,
    this.type,
    this.name,
    this.record,
  });

  factory CalendarEvent.create(Event event, Record record) {
    return CalendarEvent._(id: event.id, type: event.type, name: event.name, record: record);
  }

  factory CalendarEvent.createOnlyRecord(Record record) {
    return CalendarEvent._(id: record.id, type: EventType.none, name: null, record: record);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent._(id: event.id, type: event.type, name: event.name, record: null);
  }

  factory CalendarEvent.createEmpty(DateTime date) {
    final id = DyphicID.makeEventId(date);
    return CalendarEvent._(id: id, type: null, name: null, record: null);
  }

  final int id;
  final EventType? type;
  final String? name;
  final Record? record;

  DateTime get date => DyphicID.idToDate(id);
  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool haveRecord() => record != null;
  bool isWalking() => record?.isWalking ?? false;
  bool isToilet() => record?.isToilet ?? false;

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String toConditionNames() {
    return record?.toConditionNames() ?? '';
  }

  String getConditionMemo() {
    return record?.conditionMemo ?? '';
  }

  CalendarEvent updateRecord(Record newRecord) {
    return CalendarEvent._(id: id, type: type, name: name, record: newRecord);
  }
}

enum EventType { none, hospital, injection }

///
/// データ取得時以外は使わない
///
class Event {
  const Event({
    required this.id,
    required this.type,
    required this.name,
  });

  final int id;
  final EventType type;
  final String name;

  static EventType toType(int idx) {
    if (EventType.hospital.index == idx) {
      return EventType.hospital;
    } else if (EventType.injection.index == idx) {
      return EventType.injection;
    } else {
      return EventType.none;
    }
  }
}
