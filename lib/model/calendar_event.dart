import 'package:dyphic/model/record.dart';
import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent._({
    @required this.date,
    @required this.type,
    @required this.name,
    @required this.recordOverview,
  });

  factory CalendarEvent.create(Event event, RecordOverview record) {
    return CalendarEvent._(date: event.date, type: event.type, name: event.name, recordOverview: record);
  }

  factory CalendarEvent.createOnlyRecord(RecordOverview record) {
    return CalendarEvent._(date: record.date, type: EventType.none, name: null, recordOverview: record);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent._(date: event.date, type: event.type, name: event.name, recordOverview: null);
  }

  factory CalendarEvent.createEmpty(DateTime date) {
    return CalendarEvent._(date: date, type: null, name: null, recordOverview: null);
  }

  final DateTime date;
  final EventType type;
  final String name;
  final RecordOverview recordOverview;

  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool haveRecord() => recordOverview != null;

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String toStringConditions() {
    if (recordOverview.conditionNames == null) {
      return '';
    }
    return recordOverview.conditionNames.join(" ");
  }

  String getConditionMemo() {
    if (recordOverview.conditionMemo == null) {
      return '';
    }
    return recordOverview.conditionMemo;
  }

  CalendarEvent updateRecord(RecordOverview newRecord) {
    return CalendarEvent._(date: date, type: type, name: name, recordOverview: newRecord);
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
