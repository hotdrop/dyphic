import 'dart:convert';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';

class EventJson {
  static List<Event> parse(String json) {
    final dynamic jsonDecodeMap = jsonDecode(json);
    final results = (jsonDecodeMap['events'] as List)
        .map((dynamic obj) => obj as Map<String, dynamic>)
        .map((Map<String, dynamic> objMap) {
          return EventObject(
            dateId: objMap['date'] as int,
            name: objMap['name'] as String,
            typeIdx: objMap['type'] as int,
          );
        })
        .map((obj) => obj.toEvent())
        .toList();
    AppLogger.d('Eventをパースしました。 size=${results.length}');
    return results;
  }
}

class EventObject {
  const EventObject({
    required this.dateId,
    required this.name,
    required this.typeIdx,
  });

  final int dateId;
  final String name;
  final int typeIdx;

  Event toEvent() {
    return Event(id: dateId, type: Event.toType(typeIdx), name: name);
  }
}
