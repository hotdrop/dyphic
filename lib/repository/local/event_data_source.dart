import 'package:sqflite/sqflite.dart';

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
    final db = await _dbProvider.database;
    final results = await db.query(EventEntity.tableName);
    final List<EventEntity> entities = results.isNotEmpty ? results.map((it) => EventEntity.fromMap(it)).toList() : [];

    return entities.map((e) => e.toEvent()).toList();
  }

  Future<void> update(List<Event> events) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, events);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(EventEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Event> events) async {
    final entities = events.map((e) => e.toEntity());
    for (var entity in entities) {
      await txn.insert(EventEntity.tableName, entity.toMap());
    }
  }
}
