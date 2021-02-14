import 'package:sqflite/sqflite.dart';

import 'package:dalico/model/calendar_event.dart';
import 'package:dalico/repository/local/db_provider.dart';
import 'package:dalico/repository/local/entity/event_entity.dart';

class EventDatabase {
  const EventDatabase._(this._dbProvider);

  factory EventDatabase.create() {
    return EventDatabase._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Event>> findAll() async {
    // TODO 準備できたら有効にする
    // final db = await _dbProvider.database;
    // final results = await db.query(EventEntity.tableName);
    // final List<EventEntity> entities = results.isNotEmpty ? results.map((it) => EventEntity.fromMap(it)).toList() : [];
    // return entities.map((e) => e.toEvent()).toList();
    return [
      Event(date: DateTime(2021, 2, 11), type: EventType.hospital, name: 'この日は病院です'),
      Event(date: DateTime(2021, 2, 25), type: EventType.injection, name: 'この日は注射です。'),
    ];
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
