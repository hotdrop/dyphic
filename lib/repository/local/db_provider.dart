import 'package:dyphic/repository/local/entity/db_entity.dart';
import 'package:dyphic/repository/local/entity/event_entity.dart';
import 'package:sqflite/sqflite.dart';

///
/// sqfliteのmap変換がいちいちうざいのでCRUDは全てこのクラスで対応する
///
class DBProvider {
  const DBProvider._();

  static final DBProvider _instance = DBProvider._();
  static DBProvider get instance => _instance;

  static Database? _databaseInstance;
  Future<Database> get _database async {
    _databaseInstance ??= await _initDB();
    return _databaseInstance!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      'dyphic.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(EventEntity.createTableSql);
        // await db.execute(NoteEntity.createTableSql);
      },
    );
  }

  Future<List<T>> findAll<T extends DBEntity>(
    String tableName,
    T Function(Map<String, dynamic> map) entityFromMap,
  ) async {
    final db = await _database;
    final results = await db.query(tableName);
    return results.isNotEmpty ? results.map((it) => entityFromMap(it)).toList() : [];
  }

  Future<void> updateAll<T extends DBEntity>(String tableName, List<T> entities) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.delete(tableName);
      for (var entity in entities) {
        await txn.insert(EventEntity.tableName, entity.toMap());
      }
    });
  }

  Future<void> insert<T extends DBEntity>(String tableName, T entity) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.insert(EventEntity.tableName, entity.toMap());
    });
  }
}
