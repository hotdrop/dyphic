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
  static final String _recordConditionIDsField = 'conditionIDs';
  static final String _recordConditionMemoField = 'conditionMemo';

  Future<RecordOverview> findOverviewRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final allConditions = await findConditions();
      final dataMap = snapshot.data();
      final conditionIds = dataMap[_recordConditionIDsField] as String;
      final conditions = _convertConditions(allConditions, conditionIds);
      return RecordOverview(
        recordId: id,
        conditions: conditions,
        conditionMemo: dataMap[_recordConditionMemoField] as String,
      );
    } else {
      return null;
    }
  }

  Future<List<RecordOverview>> findOverviewRecords() async {
    final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).get();
    final allConditions = await findConditions();
    return snapshot.docs.map((doc) {
      final conditionIds = doc.get(_recordConditionIDsField) as String;
      final conditions = _convertConditions(allConditions, conditionIds);
      return RecordOverview(
        recordId: int.parse(doc.id),
        conditions: conditions,
        conditionMemo: doc.get(_recordConditionMemoField) as String,
      );
    }).toList();
  }

  Future<void> saveOverviewRecord(RecordOverview overview) async {
    final id = overview.recordId.toString();
    final map = <String, dynamic>{
      _recordConditionIDsField: overview.toStringConditionIds(),
      _recordConditionMemoField: overview.conditionMemo,
    };
    await _recordRootDoc.collection(_recordOverviewCollection).doc(id).set(map);
  }

  static final String _recordTemperatureCollection = 'temperature';
  static final String _recordMorningTemperatureField = 'morningTemperature';
  static final String _recordNightTemperatureField = 'nightTemperature';

  Future<RecordTemperature> findTemperatureRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordTemperatureCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final dataMap = snapshot.data();
      return RecordTemperature(
        recordId: id,
        morningTemperature: dataMap[_recordMorningTemperatureField] as double,
        nightTemperature: dataMap[_recordNightTemperatureField] as double,
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
        morningTemperature: doc.get(_recordMorningTemperatureField) as double,
        nightTemperature: doc.get(_recordNightTemperatureField) as double,
      );
    }).toList();
  }

  Future<void> saveTemperatureRecord(RecordTemperature temperature) async {
    final id = temperature.recordId.toString();
    final map = <String, dynamic>{
      _recordMorningTemperatureField: temperature.morningTemperature,
      _recordNightTemperatureField: temperature.nightTemperature,
    };
    await _recordRootDoc.collection(_recordTemperatureCollection).doc(id).set(map);
  }

  static final String _recordDetailCollection = 'detail';
  static final String _recordMedicineIDsField = 'medicineIDs';
  static final String _recordBreakFastField = 'breakfast';
  static final String _recordLunchField = 'lunch';
  static final String _recordDinnerField = 'dinner';
  static final String _recordMemoField = 'memo';

  Future<RecordDetail> findDetailRecord(int id) async {
    final snapshot = await _recordRootDoc.collection(_recordDetailCollection).doc(id.toString()).get();
    if (snapshot.exists) {
      final allMedicines = await findMedicines();
      final dataMap = snapshot.data();
      final medicineIds = dataMap[_recordMedicineIDsField] as String;
      final medicines = _convertMedicines(allMedicines, medicineIds);
      return RecordDetail(
        recordId: id,
        medicines: medicines,
        breakfast: dataMap[_recordBreakFastField] as String,
        lunch: dataMap[_recordLunchField] as String,
        dinner: dataMap[_recordDinnerField] as String,
        memo: dataMap[_recordMemoField] as String,
      );
    } else {
      return null;
    }
  }

  Future<void> saveDetailRecord(RecordDetail detail) async {
    final id = detail.recordId.toString();
    final map = <String, dynamic>{
      _recordMedicineIDsField: detail.toStringMedicineIds(),
      _recordBreakFastField: detail.breakfast,
      _recordLunchField: detail.lunch,
      _recordDinnerField: detail.dinner,
      _recordMemoField: detail.memo,
    };
    await _recordRootDoc.collection(_recordDetailCollection).doc(id).set(map);
  }

  List<Condition> _convertConditions(List<Condition> allConditions, String idsStr) {
    final ids = _splitIds(idsStr);
    return allConditions.where((e) => ids.contains(e.id)).toList();
  }

  List<Medicine> _convertMedicines(List<Medicine> allMedicines, String idsStr) {
    final ids = _splitIds(idsStr);
    return allMedicines.where((e) => ids.contains(e.id)).toList();
  }

  List<int> _splitIds(String nStr) {
    if (nStr == null || nStr.isEmpty) {
      return [];
    }
    if (nStr.contains(Record.listSeparator)) {
      return nStr.split(Record.listSeparator).map((id) => int.parse(id)).toList();
    } else {
      return [int.parse(nStr)];
    }
  }

  ///
  /// お薬
  ///
  static final String _medicineRootName = 'medicines';

  Future<List<Medicine>> findMedicines() async {
    final snapshot = await FirebaseFirestore.instance.collection(_medicineRootName).get();
    return snapshot.docs.map((doc) {
      return Medicine(
        id: int.parse(doc.id),
        name: doc.get('name') as String,
        overview: doc.get('overview') as String,
        imagePath: doc.get('imagePath') as String,
        type: Medicine.toType(doc.get('type') as int),
        memo: (doc.get('memo') as String) ?? '',
        order: doc.get('order') as int,
      );
    }).toList();
  }

  Future<void> saveMedicine(Medicine medicine) async {
    final id = medicine.id.toString();
    final map = <String, dynamic>{
      'name': medicine.name,
      'overview': medicine.overview,
      'type': medicine.type.index,
      'imagePath': medicine.imagePath,
      'memo': medicine.memo,
      'order': medicine.order,
    };
    await FirebaseFirestore.instance.collection(_medicineRootName).doc(id).set(map);
  }

  ///
  /// 体調
  ///
  static final String _conditionRootName = 'conditions';

  Future<List<Condition>> findConditions() async {
    final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
    return snapshot.docs.map((doc) {
      return Condition(
        int.parse(doc.id),
        doc.get('name') as String,
      );
    }).toList();
  }

  Future<void> saveCondition(Condition condition) async {
    final id = condition.id.toString();
    final map = <String, dynamic>{
      'name': condition.name,
    };
    await FirebaseFirestore.instance.collection(_conditionRootName).doc(id).set(map);
  }
}
