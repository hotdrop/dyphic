import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    @required this.date,
    @required this.type,
    @required this.name,
    @required this.haveRecord,
  });

  factory CalendarEvent.create(Event event, EventRecord record) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, haveRecord: true);
  }

  factory CalendarEvent.createOnlyRecord(EventRecord record) {
    return CalendarEvent(date: record.date, type: EventType.none, name: '', haveRecord: true);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, haveRecord: false);
  }

  factory CalendarEvent.createEmpty(DateTime date) {
    return CalendarEvent(date: date, type: null, name: null, haveRecord: false);
  }

  final DateTime date;
  final EventType type;
  final String name;
  final bool haveRecord;

  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool isRecord() => haveRecord;

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

enum EventType { none, hospital, injection }

/// データ取得時以外は使わない
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

/// データ取得時以外は使わない
class EventRecord {
  EventRecord({
    @required this.date,
  });

  final DateTime date;
}
