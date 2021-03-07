import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';

mixin AppFirestoreMixin {
  ///
  /// 記録情報詳細
  ///
  static final String _recordRootCollection = 'dyphic';
  static final String _recordRootDocument = 'records';
  DocumentReference get _recordRootDoc => FirebaseFirestore.instance.collection(_recordRootCollection).doc(_recordRootDocument);

  static final String _recordOverviewCollection = 'overview';
  static final String _recordTemperatureCollection = 'temperature';
  static final String _recordDetailCollection = 'detail';

  Future<RecordOverview> findOverviewRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final dataMap = snapshot.data();
      return RecordOverview(
        recordId: id,
        conditionNames: _splitNames(dataMap['conditions'] as String),
        conditionMemo: dataMap['conditionMemo'] as String,
      );
    } else {
      return null;
    }
  }

  Future<List<RecordOverview>> findOverviewRecords() async {
    final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).get();
    return snapshot.docs.map((doc) {
      return RecordOverview(
        recordId: int.parse(doc.id),
        conditionNames: _splitNames(doc.get('conditions') as String),
        conditionMemo: doc.get('conditionMemo') as String,
      );
    }).toList();
  }

  Future<RecordTemperature> findTemperatureRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordTemperatureCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final dataMap = snapshot.data();
      return RecordTemperature(
        recordId: id,
        morningTemperature: dataMap['morningTemperature'] as double,
        nightTemperature: dataMap['nightTemperature'] as double,
      );
    } else {
      return null;
    }
  }

  Future<List<RecordTemperature>> findTemperatureRecords() async {
    final snapshot = await _recordRootDoc.collection(_recordTemperatureCollection).get();
    return snapshot.docs.map((doc) {
      return RecordTemperature(
        recordId: int.parse(doc.id),
        morningTemperature: doc.get('morningTemperature') as double,
        nightTemperature: doc.get('nightTemperature') as double,
      );
    }).toList();
  }

  Future<Record> findDetailRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordDetailCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final dataMap = snapshot.data();
      return Record.createById(
        id: id,
        medicineNames: _splitNames(dataMap['medicines'] as String),
        breakfast: dataMap['breakfast'] as String,
        lunch: dataMap['lunch'] as String,
        dinner: dataMap['dinner'] as String,
        memo: dataMap['memo'] as String,
      );
    } else {
      return null;
    }
  }

  Future<List<Record>> findDetailRecords() async {
    final snapshot = await _recordRootDoc.collection(_recordDetailCollection).get();
    return snapshot.docs.map((doc) {
      return Record.createById(
        id: int.parse(doc.id),
        medicineNames: _splitNames(doc.get('medicines') as String),
        breakfast: doc.get('breakfast') as String,
        lunch: doc.get('lunch') as String,
        dinner: doc.get('dinner') as String,
        memo: doc.get('memo') as String,
      );
    }).toList();
  }

  Future<void> saveOverviewRecord(Record record) async {
    final recordMap = <String, dynamic>{
      'conditions': record.conditionNames.join(Record.nameSeparator),
      'conditionMemo': record.conditionMemo,
    };
    await _recordRootDoc.collection(_recordOverviewCollection).doc(record.id.toString()).set(recordMap);
  }

  Future<void> saveTemperatureRecord(Record record) async {
    final recordMap = <String, dynamic>{
      'morningTemperature': record.morningTemperature,
      'nightTemperature': record.nightTemperature,
    };
    await _recordRootDoc.collection(_recordTemperatureCollection).doc(record.id.toString()).set(recordMap);
  }

  Future<void> saveDetailRecord(Record record) async {
    final recordMap = <String, dynamic>{
      'medicines': record.medicineNames.join(Record.nameSeparator),
      'breakfast': record.breakfast,
      'lunch': record.lunch,
      'dinner': record.dinner,
      'memo': record.memo,
    };
    await _recordRootDoc.collection(_recordDetailCollection).doc(record.id.toString()).set(recordMap);
  }

  List<String> _splitNames(String nStr) {
    if (nStr == null) {
      return [];
    }
    if (nStr.contains(Record.nameSeparator)) {
      return nStr.split(Record.nameSeparator);
    } else {
      return [nStr];
    }
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
