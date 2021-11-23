import 'package:dyphic/model/event.dart';
import 'package:dyphic/repository/local/entity/event_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final eventDaoProvider = Provider((ref) => const _EventDao());

class _EventDao {
  const _EventDao();

  Future<List<Event>> findAll() async {
    final box = await Hive.openBox<EventEntity>(EventEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    return box.values.map((e) => _toEvent(e)).toList();
  }

  Future<void> saveAll(List<Event> events) async {
    final box = await Hive.openBox<EventEntity>(EventEntity.boxName);
    final entities = events.map((c) => _toEntity(c)).toList();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  EventEntity _toEntity(Event event) {
    return EventEntity(id: event.id, type: event.type.index, name: event.name);
  }

  Event _toEvent(EventEntity entity) {
    final type = Event.toType(entity.type);
    return Event(id: entity.id, type: type, name: entity.name);
  }
}
