import 'package:dyphic/model/record.dart';
import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    @required this.date,
    @required this.type,
    @required this.name,
    @required this.eventRecord,
  });

  factory CalendarEvent.create(Event event, RecordOverview record) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, eventRecord: record);
  }

  factory CalendarEvent.createOnlyRecord(RecordOverview record) {
    return CalendarEvent(date: record.date, type: EventType.none, name: null, eventRecord: record);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, eventRecord: null);
  }

  factory CalendarEvent.createEmpty(DateTime date) {
    return CalendarEvent(date: date, type: null, name: null, eventRecord: null);
  }

  final DateTime date;
  final EventType type;
  final String name;
  final RecordOverview eventRecord;

  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool haveRecord() => eventRecord != null;

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String toStringConditions() {
    if (eventRecord.conditionNames == null) {
      return '';
    }
    return eventRecord.conditionNames.join(" ");
  }

  String getConditionMemo() {
    if (eventRecord.conditionMemo == null) {
      return '';
    }
    return eventRecord.conditionMemo;
  }
}

enum EventType { none, hospital, injection }

///
/// データ取得時以外は使わない
///
class Event {
  const Event({
    @required this.date,
    @required this.type,
    @required this.name,
  });

  final DateTime date;
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
