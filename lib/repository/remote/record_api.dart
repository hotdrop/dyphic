import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/document/record_detail_doc.dart';
import 'package:dyphic/repository/remote/document/record_overview_doc.dart';
import 'package:dyphic/repository/remote/document/record_temperature_doc.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:collection/collection.dart';

final recordApiProvider = Provider((ref) => _RecordApi(ref.read));

class _RecordApi {
  const _RecordApi(this._read);

  final Reader _read;

  ///
  /// 全日の記録情報を取得する
  ///
  Future<List<Record>> findAll() async {
    List<RecordOverviewDoc> overviewResponse = [];
    List<RecordTemperatureDoc> temperatureResponse = [];
    List<RecordDetailDoc> detailsResponse = [];

    await Future.wait<void>([
      _read(appFirebaseProvider).findAllRecordOverview().then((r) => overviewResponse = r),
      _read(appFirebaseProvider).findAllTemperature().then((r) => temperatureResponse = r),
      _read(appFirebaseProvider).findAllDetails().then((r) => detailsResponse = r),
    ]);

    AppLogger.d('記録情報の取得が完了しました。記録概要: ${overviewResponse.length}件');
    if (overviewResponse.isEmpty) {
      return [];
    }

    List<Record> results = [];
    for (var overview in overviewResponse) {
      final temp = temperatureResponse.firstWhereOrNull((t) => t.recordId == overview.recordId);
      final detail = detailsResponse.firstWhereOrNull((d) => d.recordId == overview.recordId);
      final record = _merge(overview, temp, detail);
      results.add(record);
    }
    AppLogger.d('記録情報をマージしました。${results.length}件');

    return results;
  }

  Record _merge(RecordOverviewDoc overview, RecordTemperatureDoc? temp, RecordDetailDoc? detail) {
    final conditions = _read(conditionsProvider);
    final medicines = _read(medicineProvider);
    return Record(
      id: overview.recordId,
      isWalking: overview.isWalking,
      isToilet: overview.isToilet,
      conditions: Record.toConditions(conditions, overview.conditionStringIds),
      conditionMemo: overview.conditionMemo,
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
    RecordOverviewDoc? overviewDoc;
    RecordTemperatureDoc? temperatureDoc;
    RecordDetailDoc? detailsDoc;

    await Future.wait<void>([
      _read(appFirebaseProvider).findOverviewRecord(id).then((r) => overviewDoc = r),
      _read(appFirebaseProvider).findTemperatureRecord(id).then((r) => temperatureDoc = r),
      _read(appFirebaseProvider).findDetailRecord(id).then((r) => detailsDoc = r),
    ]);

    AppLogger.d('記録情報の取得が完了しました。');
    if (overviewDoc != null) {
      return _merge(overviewDoc!, temperatureDoc, detailsDoc);
    } else {
      return null;
    }
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    AppLogger.d('$recordId の朝食を保存します。');
    await _read(appFirebaseProvider).saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    AppLogger.d('$recordId の昼食を保存します。');
    await _read(appFirebaseProvider).saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    AppLogger.d('$recordId の夕食を保存します。');
    await _read(appFirebaseProvider).saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の朝体温を保存します。');
    await _read(appFirebaseProvider).saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の夜体温を保存します。');
    await _read(appFirebaseProvider).saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(Record record) async {
    AppLogger.d('${record.id} の体調情報を保存します。');
    final doc = RecordOverviewDoc(
      recordId: record.id,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionStringIds: record.toConditionIdsStr(_read(conditionsProvider)),
      conditionMemo: record.conditionMemo ?? '',
    );
    await _read(appFirebaseProvider).saveOverview(doc);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    AppLogger.d('$recordId のお薬情報を保存します。');
    await _read(appFirebaseProvider).saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    AppLogger.d('$recordId のメモを保存します。');
    await _read(appFirebaseProvider).saveMemo(recordId, memo);
  }
}
