import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:dyphic/repository/local/entity/event_entity.dart';

class DBProvider {
  const DBProvider._();

  static DBProvider _instance = DBProvider._();
  static DBProvider get instance => _instance;

  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDB();
    }
    return _database;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'dyphic.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(EventEntity.createTableSql);
      },
    );
  }
}
