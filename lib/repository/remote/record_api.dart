import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/service/app_firebase.dart';

class RecordApi {
  const RecordApi._(this._appFirebase);

  factory RecordApi.create() {
    return RecordApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<RecordOverview>> findOverviewRecords() async {
    final overviewRecords = await _appFirebase.findOverviewRecords();
    AppLogger.d('記録情報概要を全取得しました。登録数: ${overviewRecords.length}');
    return overviewRecords;
  }

  Future<RecordOverview> findOverviewRecord(int id) async {
    return await _appFirebase.findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    AppLogger.d('$id の記録情報を取得します。');
    final overview = await _appFirebase.findOverviewRecord(id);
    final temperature = await _appFirebase.findTemperatureRecord(id);
    final detail = await _appFirebase.findDetailRecord(id);
    final record = Record.create(
      id: id,
      recordOverview: overview,
      recordTemperature: temperature,
      recordDetail: detail,
    );
    return record;
  }

  Future<void> save(Record record) async {
    AppLogger.d('${record.id} の記録情報を保存します。\n${record.toString()}');
    if (record.overview != null) {
      await _appFirebase.saveOverviewRecord(record.overview);
    }
    if (record.temperature != null) {
      await _appFirebase.saveTemperatureRecord(record.temperature);
    }
    if (record.detail != null) {
      await _appFirebase.saveDetailRecord(record.detail);
    }
  }
}
