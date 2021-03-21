import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/record.dart';

class CalendarEvent {
  const CalendarEvent._({
    required this.id,
    this.type,
    this.name,
    this.recordOverview,
  });

  factory CalendarEvent.create(Event event, RecordOverview overview) {
    return CalendarEvent._(id: event.id, type: event.type, name: event.name, recordOverview: overview);
  }

  factory CalendarEvent.createOnlyRecord(RecordOverview overview) {
    return CalendarEvent._(id: overview.recordId, type: EventType.none, name: null, recordOverview: overview);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent._(id: event.id, type: event.type, name: event.name, recordOverview: null);
  }

  factory CalendarEvent.createEmpty(DateTime date) {
    final id = DyphicID.makeEventId(date);
    return CalendarEvent._(id: id, type: null, name: null, recordOverview: null);
  }

  final int id;
  final EventType? type;
  final String? name;
  final RecordOverview? recordOverview;

  DateTime get date => DyphicID.idToDate(id);
  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool haveRecord() => recordOverview != null;
  bool isWalking() => recordOverview?.isWalking ?? false;

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String toStringConditions() {
    return recordOverview?.toStringConditionNames() ?? '';
  }

  String getConditionMemo() {
    return recordOverview?.conditionMemo ?? '';
  }

  CalendarEvent updateRecord(RecordOverview newRecord) {
    return CalendarEvent._(id: id, type: type, name: name, recordOverview: newRecord);
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
