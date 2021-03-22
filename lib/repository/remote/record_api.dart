import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/service/app_firebase.dart';

class RecordApi {
  const RecordApi._(this._appFirebase);

  factory RecordApi.create() {
    return RecordApi._(AppFirebase.instance);
  }

  final AppFirebase _appFirebase;

  Future<List<RecordOverview>> findOverviewRecords() async {
    final overviewRecords = await _appFirebase.findOverviewRecords();
    AppLogger.d('記録情報概要を全取得しました。登録数: ${overviewRecords.length}');
    return overviewRecords;
  }

  Future<RecordOverview?> findOverviewRecord(int id) async {
    return await _appFirebase.findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    AppLogger.d('$id の記録情報を取得します。');
    final RecordOverview? overview = await _appFirebase.findOverviewRecord(id);
    final RecordTemperature? temperature = await _appFirebase.findTemperatureRecord(id);
    final RecordDetail? detail = await _appFirebase.findDetailRecord(id);

    final record = Record.create(
      id: id,
      recordOverview: overview,
      recordTemperature: temperature,
      recordDetail: detail,
    );
    return record;
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    AppLogger.d('$recordId の朝食を保存します。');
    await _appFirebase.saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    AppLogger.d('$recordId の昼食を保存します。');
    await _appFirebase.saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    AppLogger.d('$recordId の夕食を保存します。');
    await _appFirebase.saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の朝体温を保存します。');
    await _appFirebase.saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の夜体温を保存します。');
    await _appFirebase.saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(RecordOverview overview) async {
    AppLogger.d('${overview.recordId} の体調情報を保存します。');
    await _appFirebase.saveOverview(overview);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    AppLogger.d('$recordId のお薬情報を保存します。');
    await _appFirebase.saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    AppLogger.d('$recordId のメモを保存します。');
    await _appFirebase.saveMemo(recordId, memo);
  }
}
