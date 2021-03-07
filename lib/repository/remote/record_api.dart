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

  Future<Record> find(int id) async {
    AppLogger.d('$id の記録情報を取得します。');
    final o = await _appFirebase.findOverviewRecord(id);
    final t = await _appFirebase.findTemperatureRecord(id);
    final d = await _appFirebase.findDetailRecord(id);
    final record =
        Record.createById(id: id, recordOverview: o, recordTemperature: t, medicineNames: d.medicineNames, breakfast: d.breakfast, lunch: d.lunch, dinner: d.dinner, memo: d.memo);
    return record;
  }

  Future<void> save(Record record) async {
    AppLogger.d('${record.id} の記録情報を保存します。\n${record.toString()}');
    await _appFirebase.saveOverviewRecord(record);
    await _appFirebase.saveTemperatureRecord(record);
    await _appFirebase.saveDetailRecord(record);
  }
}
