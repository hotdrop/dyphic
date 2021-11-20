import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/document/record_detail_doc.dart';
import 'package:dyphic/repository/remote/document/record_overview_doc.dart';
import 'package:dyphic/repository/remote/document/record_temperature_doc.dart';

mixin AppFirestoreMixin {
  static const String _recordRootCollection = 'dyphic';
  static const String _recordRootDocument = 'records';
  DocumentReference get _recordRootDoc => FirebaseFirestore.instance //
      .collection(_recordRootCollection)
      .doc(_recordRootDocument);

  static const String _recordOverviewCollection = 'overview';
  static const String _recordTemperatureCollection = 'temperature';
  static const String _recordDetailCollection = 'detail';

  static const String _recordOverviewIsWalking = 'isWalking';
  static const String _recordOverviewIsToilet = 'isToilet';
  static const String _recordConditionIDsField = 'conditionIDs';
  static const String _recordConditionMemoField = 'conditionMemo';

  static const String _recordMorningTemperatureField = 'morningTemperature';
  static const String _recordNightTemperatureField = 'nightTemperature';

  static const String _recordMedicineIDsField = 'medicineIDs';
  static const String _recordBreakFastField = 'breakfast';
  static const String _recordLunchField = 'lunch';
  static const String _recordDinnerField = 'dinner';
  static const String _recordMemoField = 'memo';

  ///
  /// 記録概要を全取得
  ///
  Future<List<RecordOverviewDoc>> findAllRecordOverview() async {
    final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return RecordOverviewDoc(
        recordId: int.parse(doc.id),
        isWalking: _getBool(map, _recordOverviewIsWalking),
        isToilet: _getBool(map, _recordOverviewIsToilet),
        conditionStringIds: _getString(map, _recordConditionIDsField),
        conditionMemo: _getString(map, _recordConditionMemoField),
      );
    }).toList();
  }

  ///
  /// 指定したIDの記録概要を取得
  ///
  Future<RecordOverviewDoc?> findOverviewRecord(int id) async {
    final snapshot = await _recordRootDoc //
        .collection(_recordOverviewCollection)
        .doc(id.toString())
        .get();

    if (!snapshot.exists) {
      return null;
    }

    final map = snapshot.data();
    return RecordOverviewDoc(
      recordId: int.parse(snapshot.id),
      isWalking: _getBool(map, _recordOverviewIsWalking),
      isToilet: _getBool(map, _recordOverviewIsToilet),
      conditionStringIds: _getString(map, _recordConditionIDsField),
      conditionMemo: _getString(map, _recordConditionMemoField),
    );
  }

  ///
  /// 体温情報を全取得
  ///
  Future<List<RecordTemperatureDoc>> findAllTemperature() async {
    final snapshot = await _recordRootDoc.collection(_recordTemperatureCollection).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return RecordTemperatureDoc(
        recordId: int.parse(doc.id),
        morningTemperature: _getDouble(map, _recordMorningTemperatureField),
        nightTemperature: _getDouble(map, _recordNightTemperatureField),
      );
    }).toList();
  }

  ///
  /// 指定したIDの体温情報を取得
  ///
  Future<RecordTemperatureDoc?> findTemperatureRecord(int id) async {
    final snapshot = await _recordRootDoc //
        .collection(_recordTemperatureCollection)
        .doc(id.toString())
        .get();

    if (!snapshot.exists) {
      return null;
    }

    final map = snapshot.data();
    return RecordTemperatureDoc(
      recordId: id,
      morningTemperature: _getDouble(map, _recordMorningTemperatureField),
      nightTemperature: _getDouble(map, _recordNightTemperatureField),
    );
  }

  ///
  /// 記録詳細情報を全取得
  ///
  Future<List<RecordDetailDoc>> findAllDetails() async {
    final snapshot = await _recordRootDoc.collection(_recordDetailCollection).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return RecordDetailDoc(
        recordId: int.parse(doc.id),
        medicineStrIds: _getString(map, _recordMedicineIDsField),
        breakfast: _getString(map, _recordBreakFastField),
        lunch: _getString(map, _recordLunchField),
        dinner: _getString(map, _recordDinnerField),
        memo: _getString(map, _recordMemoField),
      );
    }).toList();
  }

  ///
  /// 指定したIDの記録詳細情報を取得
  ///
  Future<RecordDetailDoc?> findDetailRecord(int id) async {
    final snapshot = await _recordRootDoc //
        .collection(_recordDetailCollection)
        .doc(id.toString())
        .get();

    if (snapshot.exists) {
      return null;
    }

    final map = snapshot.data();
    return RecordDetailDoc(
      recordId: id,
      medicineStrIds: _getString(map, _recordMedicineIDsField),
      breakfast: _getString(map, _recordBreakFastField),
      lunch: _getString(map, _recordLunchField),
      dinner: _getString(map, _recordDinnerField),
      memo: _getString(map, _recordMemoField),
    );
  }

  Future<void> saveOverview(RecordOverviewDoc overview) async {
    final map = <String, dynamic>{
      _recordConditionIDsField: overview.conditionStringIds,
      _recordConditionMemoField: overview.conditionMemo,
      _recordOverviewIsWalking: overview.isWalking,
      _recordOverviewIsToilet: overview.isToilet,
    };
    await _saveField(overview.recordId.toString(), _recordOverviewCollection, map);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    final map = <String, dynamic>{_recordMorningTemperatureField: temperature};
    await _saveField(recordId.toString(), _recordTemperatureCollection, map);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    final map = <String, dynamic>{_recordNightTemperatureField: temperature};
    await _saveField(recordId.toString(), _recordTemperatureCollection, map);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    final map = <String, dynamic>{_recordMedicineIDsField: idsStr};
    await _saveField(recordId.toString(), _recordDetailCollection, map);
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    final map = <String, dynamic>{_recordBreakFastField: breakFast};
    await _saveField(recordId.toString(), _recordDetailCollection, map);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    final map = <String, dynamic>{_recordLunchField: lunch};
    await _saveField(recordId.toString(), _recordDetailCollection, map);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    final map = <String, dynamic>{_recordDinnerField: dinner};
    await _saveField(recordId.toString(), _recordDetailCollection, map);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    final map = <String, dynamic>{_recordMemoField: memo};
    await _saveField(recordId.toString(), _recordDetailCollection, map);
  }

  Future<void> _saveField(String id, String collectionName, Map<String, dynamic> map) async {
    await _recordRootDoc
        .collection(collectionName) //
        .doc(id)
        .set(map, SetOptions(merge: true));
  }

  ///
  /// お薬
  ///
  static const String _medicineRootName = 'medicines';

  Future<List<Medicine>> findMedicines() async {
    final snapshot = await FirebaseFirestore.instance.collection(_medicineRootName).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return Medicine(
        id: int.parse(doc.id),
        name: _getString(map, 'name'),
        overview: _getString(map, 'overview'),
        imagePath: _getString(map, 'imagePath'),
        type: Medicine.toType(_getInt(map, 'type')),
        memo: _getString(map, 'memo'),
        order: _getInt(map, 'order'),
      );
    }).toList();
  }

  Future<Medicine> findMedicine(int id) async {
    final doc = await FirebaseFirestore.instance //
        .collection(_conditionRootName)
        .doc(id.toString())
        .get();

    final map = doc.data();
    return Medicine(
      id: int.parse(doc.id),
      name: _getString(map, 'name'),
      overview: _getString(map, 'overview'),
      imagePath: _getString(map, 'imagePath'),
      type: Medicine.toType(_getInt(map, 'type')),
      memo: _getString(map, 'memo'),
      order: _getInt(map, 'order'),
    );
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
  static const String _conditionRootName = 'conditions';

  Future<List<Condition>> findConditions() async {
    final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return Condition(
        int.parse(doc.id),
        _getString(map, 'name'),
      );
    }).toList();
  }

  Future<Condition> findCondition(int id) async {
    final doc = await FirebaseFirestore.instance //
        .collection(_conditionRootName)
        .doc(id.toString())
        .get();

    final map = doc.data();
    return Condition(
      int.parse(doc.id),
      _getString(map, 'name'),
    );
  }

  Future<void> saveCondition(Condition condition) async {
    final id = condition.id.toString();
    final map = <String, dynamic>{'name': condition.name};
    await FirebaseFirestore.instance.collection(_conditionRootName).doc(id).set(map);
  }

  ///
  /// ノート
  ///
  static const String _noteRootName = 'notes';

  Future<List<Note>> findNotes() async {
    final snapshot = await FirebaseFirestore.instance.collection(_noteRootName).get();
    return snapshot.docs.map((doc) {
      final map = doc.data();
      return Note(
        id: int.parse(doc.id),
        typeValue: _getInt(map, 'typeValue'),
        title: _getString(map, 'title'),
        detail: _getString(map, 'detail'),
      );
    }).toList();
  }

  Future<void> saveNote(Note note) async {
    final id = note.id.toString();
    final map = <String, dynamic>{
      'typeValue': note.typeValue,
      'title': note.title,
      'detail': note.detail,
    };
    await FirebaseFirestore.instance.collection(_noteRootName).doc(id).set(map);
  }

  // ここから下はMapとDocumentSnapshotから型情報を取得するための共通メソッド

  int _getInt(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is int) {
      return fieldVal;
    } else {
      return 0;
    }
  }

  String _getString(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is String) {
      return fieldVal;
    } else {
      return '';
    }
  }

  bool _getBool(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is bool) {
      return fieldVal;
    } else {
      return false;
    }
  }

  double _getDouble(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is double) {
      return fieldVal;
    } else {
      return 0;
    }
  }
}
