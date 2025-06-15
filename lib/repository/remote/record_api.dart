import 'package:dyphic/common/app_extension.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/local/dao/medicine_dao.dart';
import 'package:dyphic/service/firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/document/record_detail_doc.dart';
import 'package:dyphic/repository/remote/document/record_overview_doc.dart';
import 'package:dyphic/repository/remote/document/record_temperature_doc.dart';

final recordApiProvider = Provider((ref) => _RecordApi(ref));

class _RecordApi {
  const _RecordApi(this._ref);

  final Ref _ref;

  ///
  /// 全日の記録情報を取得する
  ///
  Future<List<Record>> findAll() async {
    AppLogger.d('サーバーから記録情報を全取得します。');
    List<RecordOverviewDoc> overviewResponse = [];
    List<RecordTemperatureDoc> temperatureResponse = [];
    List<RecordDetailDoc> detailsResponse = [];

    await Future.wait<void>([
      _ref.read(firestoreProvider).findAllRecordOverview().then((r) => overviewResponse = r),
      _ref.read(firestoreProvider).findAllTemperature().then((r) => temperatureResponse = r),
      _ref.read(firestoreProvider).findAllDetails().then((r) => detailsResponse = r),
    ]);

    AppLogger.d('記録情報の取得が完了しました。記録概要: ${overviewResponse.length}件');
    if (overviewResponse.isEmpty) {
      return [];
    }

    final conditions = await _ref.read(conditionDaoProvider).findAll();
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    List<Record> results = [];
    for (var overview in overviewResponse) {
      final temp = temperatureResponse.firstWhereOrNull((t) => t.recordId == overview.recordId);
      final detail = detailsResponse.firstWhereOrNull((d) => d.recordId == overview.recordId);
      final record = _merge(overview, temp, detail, conditions, medicines);
      results.add(record);
    }
    AppLogger.d('記録情報をマージしました。${results.length}件');

    return results;
  }

  Record _merge(
    RecordOverviewDoc overview,
    RecordTemperatureDoc? temp,
    RecordDetailDoc? detail,
    List<Condition> conditions,
    List<Medicine> medicines,
  ) {
    return Record(
      id: overview.recordId,
      isWalking: overview.isWalking,
      isToilet: overview.isToilet,
      conditions: Record.toConditions(conditions, overview.conditionStringIds),
      conditionMemo: overview.conditionMemo,
      eventType: detail?.eventType ?? EventType.none,
      eventName: detail?.eventName,
      morningTemperature: temp?.morningTemperature,
      nightTemperature: temp?.nightTemperature,
      medicines: Record.toMedicines(medicines, detail?.medicineStrIds),
      breakfast: detail?.breakfast,
      lunch: detail?.lunch,
      dinner: detail?.dinner,
      memo: detail?.memo,
    );
  }

  ///
  /// 指定したIDの記録情報を取得する
  ///
  Future<Record?> find(int id) async {
    AppLogger.d('サーバーからID=$idの記録情報を取得します。');
    RecordOverviewDoc? overviewDoc;
    RecordTemperatureDoc? temperatureDoc;
    RecordDetailDoc? detailsDoc;

    await Future.wait<void>([
      _ref.read(firestoreProvider).findOverviewRecord(id).then((r) => overviewDoc = r),
      _ref.read(firestoreProvider).findTemperatureRecord(id).then((r) => temperatureDoc = r),
      _ref.read(firestoreProvider).findDetailRecord(id).then((r) => detailsDoc = r),
    ]);

    AppLogger.d('記録情報の取得が完了しました。');
    if (overviewDoc != null) {
      final conditions = await _ref.read(conditionDaoProvider).findAll();
      final medicines = await _ref.read(medicineDaoProvider).findAll();
      return _merge(overviewDoc!, temperatureDoc, detailsDoc, conditions, medicines);
    } else {
      return null;
    }
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    AppLogger.d('$recordId の朝食を保存します。');
    await _ref.read(firestoreProvider).saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    AppLogger.d('$recordId の昼食を保存します。');
    await _ref.read(firestoreProvider).saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    AppLogger.d('$recordId の夕食を保存します。');
    await _ref.read(firestoreProvider).saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の朝体温を保存します。');
    await _ref.read(firestoreProvider).saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の夜体温を保存します。');
    await _ref.read(firestoreProvider).saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(Record record) async {
    AppLogger.d('${record.id} の体調情報を保存します。');
    final doc = RecordOverviewDoc(
      recordId: record.id,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionStringIds: record.toConditionIdsStr(),
      conditionMemo: record.conditionMemo ?? '',
    );
    await _ref.read(firestoreProvider).saveOverview(doc);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    AppLogger.d('$recordId のお薬情報を保存します。');
    await _ref.read(firestoreProvider).saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    AppLogger.d('$recordId のメモを保存します。');
    await _ref.read(firestoreProvider).saveMemo(recordId, memo);
  }

  Future<void> saveEvent(int recordId, EventType eventType, String eventName) async {
    AppLogger.d('$recordId のイベント情報を保存します。');
    await _ref.read(firestoreProvider).saveEvent(recordId, eventType, eventName);
  }
}
