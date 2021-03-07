import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';

mixin AppFirestoreMixin {
  ///
  /// 記録情報詳細
  ///
  static final String _recordRootName = 'records';

  Future<List<Record>> readRecords() async {
    final snapshot = await FirebaseFirestore.instance.collection(_recordRootName).get();
    return snapshot.docs.map((doc) => _fromSnapshotByRecord(doc)).toList();
  }

  Future<Record> readRecord(int id) async {
    final snapshot = await FirebaseFirestore.instance.collection(_recordRootName).doc(id.toString()).get();
    return _fromMapToRecord(id, snapshot.data());
  }

  Future<void> writeRecord(Record record) async {
    await FirebaseFirestore.instance.collection(_recordRootName).doc(record.id.toString()).set(record.toMap());
  }

  Record _fromSnapshotByRecord(DocumentSnapshot doc) {
    final medicineNameStr = doc.get('medicineNameStr') as String;
    final conditionNameStr = doc.get('conditionNames') as String;
    return Record.createById(
      id: int.parse(doc.id),
      morningTemperature: doc.get('morningTemperature') as double,
      nightTemperature: doc.get('nightTemperature') as double,
      medicineNames: medicineNameStr.split(Record.nameSeparator),
      conditionNames: conditionNameStr.split(Record.nameSeparator),
      conditionMemo: doc.get('conditionMemo') as String,
      breakfast: doc.get('breakfast') as String,
      lunch: doc.get('lunch') as String,
      dinner: doc.get('dinner') as String,
      memo: doc.get('memo') as String,
    );
  }

  Record _fromMapToRecord(int id, Map<String, dynamic> map) {
    final medicineNameStr = map['medicineNames'] as String;
    final conditionNameStr = map['conditionNames'] as String;
    return Record.createById(
      id: id,
      morningTemperature: map['morningTemperature'] as double,
      nightTemperature: map['nightTemperature'] as double,
      medicineNames: medicineNameStr.split(Record.nameSeparator),
      conditionNames: conditionNameStr.split(Record.nameSeparator),
      conditionMemo: map['conditionMemo'] as String,
      breakfast: map['breakfast'] as String,
      lunch: map['lunch'] as String,
      dinner: map['dinner'] as String,
      memo: map['memo'] as String,
    );
  }

  ///
  /// お薬
  ///
  static final String _medicineRootName = 'medicines';

  Future<List<Medicine>> readMedicines() async {
    final snapshot = await FirebaseFirestore.instance.collection(_medicineRootName).get();
    return snapshot.docs.map((doc) => _fromSnapshotToMedicine(doc)).toList();
  }

  Future<void> writeMedicine(Medicine medicine) async {
    await FirebaseFirestore.instance.collection(_medicineRootName).doc(medicine.id.toString()).set(medicine.toMap());
  }

  Medicine _fromSnapshotToMedicine(DocumentSnapshot doc) {
    return Medicine(
      id: int.parse(doc.id),
      name: doc.get('name') as String,
      overview: doc.get('overview') as String,
      imagePath: doc.get('imagePath') as String,
      type: Medicine.toType(doc.get('type') as int),
      memo: (doc.get('memo') as String) ?? '',
      order: doc.get('order') as int,
    );
  }

  ///
  /// 体調
  ///
  static final String _conditionRootName = 'conditions';

  Future<List<Condition>> readConditions() async {
    final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
    return snapshot.docs.map((doc) => _fromSnapshotToCondition(doc)).toList();
  }

  Future<void> writeCondition(Condition condition) async {
    await FirebaseFirestore.instance.collection(_conditionRootName).doc(condition.id.toString()).set(condition.toMap());
  }

  Condition _fromSnapshotToCondition(DocumentSnapshot doc) {
    return Condition(
      int.parse(doc.id),
      doc.get('name') as String,
    );
  }
}
