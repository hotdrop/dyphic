import 'dart:convert';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';

class EventJson {
  static List<Event> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = (jsonMap['events'] as List)?.map((dynamic obj) => EventObject.fromJson(obj as Map<String, dynamic>))?.toList() ?? [];
    AppLogger.d('Eventをパースしました。 size=${results.length}');
    return results.map((obj) => obj.toEvent()).toList();
  }
}

class EventObject {
  const EventObject({this.dateId, this.name, this.typeIdx});

  static EventObject fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return EventObject(
      dateId: json['date'] as int,
      typeIdx: json['type'] as int,
      name: json['name'] as String,
    );
  }

  final int dateId;
  final String name;
  final int typeIdx;

  Event toEvent() {
    return Event(id: dateId, type: Event.toType(typeIdx), name: name);
  }
}
