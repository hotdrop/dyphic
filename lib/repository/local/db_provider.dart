import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
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
    final docDir = await getApplicationDocumentsDirectory();
    final path = join(docDir.path, 'dyphic.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        final batch = db.batch();
        _createTable(batch);
        await batch.commit();
      },
    );
  }

  void _createTable(Batch batch) {
    batch.execute(EventEntity.createTableSql);
  }
}
