import 'package:dalico/model/medicine.dart';

class MedicineEntity {
  MedicineEntity(this.name, this.isOral, this.detail);

  MedicineEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        name = map[columnName] as String,
        isOral = map[columnIsOral] as int,
        detail = map[columnDetail] as String;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{columnName: name, columnIsOral: isOral, columnDetail: detail};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  static const String tableName = 'Medicine';
  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY autoincrement,
      $columnName TEXT,
      $columnIsOral INTEGER,
      $columnDetail TEXT
    )
  ''';

  static const String columnId = 'id';
  int id;

  static const String columnName = 'name';
  String name;

  static const int oral = 1;
  static const int notOral = 0;
  static const String columnIsOral = 'isOral';
  int isOral;

  static const String columnDetail = 'detail';
  String detail;
}

extension MedicineMapper on Medicine {
  MedicineEntity toEntity() {
    final isOral = this.isOral ? MedicineEntity.oral : MedicineEntity.notOral;
    return MedicineEntity(this.name, isOral, this.detail);
  }
}

extension MedicineEntityMapper on MedicineEntity {
  Medicine toMedicine() {
    final isOral = this.isOral == MedicineEntity.oral ? true : false;
    return Medicine(name: this.name, isOral: isOral, detail: this.detail);
  }
}
