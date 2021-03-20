import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/db_provider.dart';
import 'package:dyphic/repository/local/entity/event_entity.dart';

class EventDataSource {
  const EventDataSource._(this._dbProvider);

  factory EventDataSource.create() {
    return EventDataSource._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Event>> findAll() async {
    final entities = await _dbProvider.findAll(EventEntity.tableName, EventEntity.fromMap);
    return entities.map((e) => e.toEvent()).toList();
  }

  Future<void> update(List<Event> events) async {
    final entities = events.map((e) => e.toEntity()).toList();
    await _dbProvider.updateAll<EventEntity>(EventEntity.tableName, entities);
  }
}
