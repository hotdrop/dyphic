import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    @required this.date,
    @required this.type,
    @required this.name,
    @required this.recordId,
  });

  factory CalendarEvent.create(Event event, EventRecord record) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, recordId: record.recordId);
  }

  factory CalendarEvent.createOnlyRecord(EventRecord record) {
    return CalendarEvent(date: record.date, type: EventType.none, name: '', recordId: record.recordId);
  }

  factory CalendarEvent.createOnlyEvent(Event event) {
    return CalendarEvent(date: event.date, type: event.type, name: event.name, recordId: noneRecordId);
  }

  static int noneRecordId = 0;

  final DateTime date;
  final EventType type;
  final String name;
  final int recordId;

  bool typeMedical() => type == EventType.hospital;
  bool typeInjection() => type == EventType.injection;
  bool isRecord() => recordId != noneRecordId;
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
    @required this.recordId,
  });

  final DateTime date;
  final int recordId;
}
