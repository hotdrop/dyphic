import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/model/record.dart';

mixin AppFirestoreMixin {
  ///
  /// 記録情報詳細
  ///
  static const String _recordRootCollection = 'dyphic';
  static const String _recordRootDocument = 'records';
  DocumentReference get _recordRootDoc => FirebaseFirestore.instance.collection(_recordRootCollection).doc(_recordRootDocument);

  static const String _recordOverviewCollection = 'overview';
  static const String _recordOverviewIsWalking = 'isWalking';
  static const String _recordOverviewIsToilet = 'isToilet';
  static const String _recordConditionIDsField = 'conditionIDs';
  static const String _recordConditionMemoField = 'conditionMemo';

  Future<RecordOverview?> findOverviewRecord(int id) async {
    try {
      final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).doc(id.toString()).get();
      if (snapshot.exists) {
        final allConditions = await findConditions();
        final map = snapshot.data();
        final conditionIds = getString(map, _recordConditionIDsField);
        final conditions = _convertConditions(allConditions, conditionIds);
        return RecordOverview(
          recordId: id,
          isWalking: getBool(map, _recordOverviewIsWalking),
          isToilet: getBool(map, _recordOverviewIsToilet),
          conditions: conditions,
          conditionMemo: getString(map, _recordConditionMemoField),
        );
      } else {
        return null;
      }
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: id=$id のrecords-overviewの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<List<RecordOverview>> findOverviewRecords() async {
    try {
      final snapshot = await _recordRootDoc.collection(_recordOverviewCollection).get();
      final allConditions = await findConditions();
      return snapshot.docs.map((doc) {
        final map = doc.data();
        final conditionIds = getString(map, _recordConditionIDsField);
        final conditions = _convertConditions(allConditions, conditionIds);
        return RecordOverview(
          recordId: int.parse(doc.id),
          isWalking: getBool(map, _recordOverviewIsWalking),
          isToilet: getBool(map, _recordOverviewIsToilet),
          conditions: conditions,
          conditionMemo: getString(map, _recordConditionMemoField),
        );
      }).toList();
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: records-overviewの全件取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveOverview(RecordOverview overview) async {
    final map = <String, dynamic>{
      _recordConditionIDsField: overview.toStringConditionIds(),
      _recordConditionMemoField: overview.conditionMemo,
      _recordOverviewIsWalking: overview.isWalking,
      _recordOverviewIsToilet: overview.isToilet,
    };
    await _saveField(overview.recordId.toString(), _recordOverviewCollection, map);
  }

  static const String _recordTemperatureCollection = 'temperature';
  static const String _recordMorningTemperatureField = 'morningTemperature';
  static const String _recordNightTemperatureField = 'nightTemperature';

  Future<RecordTemperature?> findTemperatureRecord(int id) async {
    try {
      final snapshot = await _recordRootDoc.collection(_recordTemperatureCollection).doc(id.toString()).get();
      if (snapshot.exists) {
        final map = snapshot.data();
        return RecordTemperature(
          recordId: id,
          morningTemperature: getDouble(map, _recordMorningTemperatureField),
          nightTemperature: getDouble(map, _recordNightTemperatureField),
        );
      } else {
        return null;
      }
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: id=$id のrecords-temperatureの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    final map = <String, dynamic>{_recordMorningTemperatureField: temperature};
    await _saveField(recordId.toString(), _recordTemperatureCollection, map);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    final map = <String, dynamic>{_recordNightTemperatureField: temperature};
    await _saveField(recordId.toString(), _recordTemperatureCollection, map);
  }

  static const String _recordDetailCollection = 'detail';
  static const String _recordMedicineIDsField = 'medicineIDs';
  static const String _recordBreakFastField = 'breakfast';
  static const String _recordLunchField = 'lunch';
  static const String _recordDinnerField = 'dinner';
  static const String _recordMemoField = 'memo';

  Future<RecordDetail?> findDetailRecord(int id) async {
    try {
      final snapshot = await _recordRootDoc.collection(_recordDetailCollection).doc(id.toString()).get();
      if (snapshot.exists) {
        final allMedicines = await findMedicines();
        final map = snapshot.data();
        final medicineIds = getString(map, _recordMedicineIDsField);
        final medicines = _convertMedicines(allMedicines, medicineIds);
        return RecordDetail(
          recordId: id,
          medicines: medicines,
          breakfast: getString(map, _recordBreakFastField),
          lunch: getString(map, _recordLunchField),
          dinner: getString(map, _recordDinnerField),
          memo: getString(map, _recordMemoField),
        );
      } else {
        return null;
      }
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: id=$id のrecords-detailの取得に失敗', e, s);
      rethrow;
    }
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

  List<Condition> _convertConditions(List<Condition> allConditions, String idsStr) {
    final ids = _splitIds(idsStr);
    return allConditions.where((e) => ids.contains(e.id)).toList();
  }

  List<Medicine> _convertMedicines(List<Medicine> allMedicines, String idsStr) {
    final ids = _splitIds(idsStr);
    return allMedicines.where((e) => ids.contains(e.id)).toList();
  }

  List<int> _splitIds(String nStr) {
    if (nStr.isEmpty) {
      return [];
    }
    if (nStr.contains(Record.listSeparator)) {
      return nStr.split(Record.listSeparator).map((id) => int.parse(id)).toList();
    } else {
      return [int.parse(nStr)];
    }
  }

  Future<void> _saveField(String id, String collectionName, Map<String, dynamic> map) async {
    try {
      await _recordRootDoc.collection(collectionName).doc(id).set(map, SetOptions(merge: true));
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: id=$id の $collectionName の保存に失敗', e, s);
      rethrow;
    }
  }

  ///
  /// お薬
  ///
  static const String _medicineRootName = 'medicines';

  Future<List<Medicine>> findMedicines() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection(_medicineRootName).get();
      return snapshot.docs.map((doc) {
        final map = doc.data();
        return Medicine(
          id: int.parse(doc.id),
          name: getString(map, 'name'),
          overview: getString(map, 'overview'),
          imagePath: getString(map, 'imagePath'),
          type: Medicine.toType(getInt(map, 'type')),
          memo: getString(map, 'memo'),
          order: getInt(map, 'order'),
        );
      }).toList();
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: medicinesの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<Medicine> findMedicine(int id) async {
    try {
      final doc = await FirebaseFirestore.instance //
          .collection(_conditionRootName)
          .doc(id.toString())
          .get();

      final map = doc.data();
      return Medicine(
        id: int.parse(doc.id),
        name: getString(map, 'name'),
        overview: getString(map, 'overview'),
        imagePath: getString(map, 'imagePath'),
        type: Medicine.toType(getInt(map, 'type')),
        memo: getString(map, 'memo'),
        order: getInt(map, 'order'),
      );
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: conditionの取得に失敗', e, s);
      rethrow;
    }
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

    try {
      await FirebaseFirestore.instance.collection(_medicineRootName).doc(id).set(map);
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: medicine(id=$id name=${medicine.name})の保存に失敗', e, s);
      rethrow;
    }
  }

  ///
  /// 体調
  ///
  static const String _conditionRootName = 'conditions';

  Future<List<Condition>> findConditions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
      return snapshot.docs.map((doc) {
        final map = doc.data();
        return Condition(
          int.parse(doc.id),
          getString(map, 'name'),
        );
      }).toList();
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: conditionsの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<Condition> findCondition(int id) async {
    try {
      final doc = await FirebaseFirestore.instance //
          .collection(_conditionRootName)
          .doc(id.toString())
          .get();

      final map = doc.data();
      return Condition(
        int.parse(doc.id),
        getString(map, 'name'),
      );
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: conditionの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveCondition(Condition condition) async {
    final id = condition.id.toString();
    final map = <String, dynamic>{
      'name': condition.name,
    };
    try {
      await FirebaseFirestore.instance.collection(_conditionRootName).doc(id).set(map);
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: condition(id=$id name=${condition.name})の保存に失敗', e, s);
      rethrow;
    }
  }

  ///
  /// ノート
  ///
  static const String _noteRootName = 'notes';

  Future<List<Note>> findNotes() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection(_noteRootName).get();
      return snapshot.docs.map((doc) {
        final map = doc.data();
        return Note(
          id: int.parse(doc.id),
          typeValue: getInt(map, 'typeValue'),
          title: getString(map, 'title'),
          detail: getString(map, 'detail'),
        );
      }).toList();
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: notesの取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveNote(Note note) async {
    final id = note.id.toString();
    final map = <String, dynamic>{
      'typeValue': note.typeValue,
      'title': note.title,
      'detail': note.detail,
    };
    try {
      await FirebaseFirestore.instance.collection(_noteRootName).doc(id).set(map);
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: note(id=$id title=${note.title})の保存に失敗', e, s);
      rethrow;
    }
  }

  // ここから下はMapとDocumentSnapshotから型情報ありで取りたい場合の便利メソッド

  int getInt(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is int) {
      return fieldVal;
    } else {
      return 0;
    }
  }

  String getString(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is String) {
      return fieldVal;
    } else {
      return '';
    }
  }

  bool getBool(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is bool) {
      return fieldVal;
    } else {
      return false;
    }
  }

  double getDouble(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is double) {
      return fieldVal;
    } else {
      return 0;
    }
  }
}
