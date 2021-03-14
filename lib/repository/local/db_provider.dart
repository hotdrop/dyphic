import 'package:sqflite/sqflite.dart';

import 'package:dyphic/repository/local/entity/event_entity.dart';

class DBProvider {
  const DBProvider._();

  static final DBProvider _instance = DBProvider._();
  static DBProvider get instance => _instance;

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      'dyphic.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(EventEntity.createTableSql);
      },
    );
  }
}
