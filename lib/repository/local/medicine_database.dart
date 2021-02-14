import 'package:dalico/model/medicine.dart';
import 'package:dalico/repository/local/db_provider.dart';
import 'package:dalico/repository/local/entity/medicine_entity.dart';
import 'package:sqflite/sqflite.dart';

class MedicineDatabase {
  const MedicineDatabase._(this._dbProvider);

  factory MedicineDatabase.create() {
    return MedicineDatabase._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Medicine>> findAll() async {
    // TODO 準備できたら有効にする
    // final db = await _dbProvider.database;
    // final results = await db.query(MedicineEntity.tableName);
    // final List<MedicineEntity> entities = results.isNotEmpty ? results.map((it) => MedicineEntity.fromMap(it)).toList() : [];
    // return entities.map((e) => e.toMedicine()).toList();
    return [
      Medicine(name: '酸化マグネシウム', isOral: false, detail: '下剤です。多くの水と一緒に服用します。'),
      Medicine(name: '内服薬その1', isOral: true, detail: '朝食後に飲みます。'),
    ];
  }

  Future<void> update(List<Medicine> medicines) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, medicines);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(MedicineEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Medicine> medicines) async {
    final entities = medicines.map((e) => e.toEntity());
    for (var entity in entities) {
      await txn.insert(MedicineEntity.tableName, entity.toMap());
    }
  }
}
