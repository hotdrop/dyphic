import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/service/app_firebase.dart';

class RecordApi {
  const RecordApi._(this._appFirebase);

  factory RecordApi.create() {
    return RecordApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<RecordOverview>> findEventRecords() async {
    final records = await _appFirebase.readRecords();
    AppLogger.d('記録情報が登録された日付を全て取得しました。登録数: ${records.length}');

    final overviewRecords = records
        .map((r) => RecordOverview(
              date: r.date,
              conditionNames: r.conditionNames,
              conditionMemo: r.conditionMemo,
            ))
        .toList();

    return overviewRecords;
  }

  Future<Record> find(int id) async {
    AppLogger.d('$id の記録情報を取得します。');
    return await _appFirebase.readRecord(id);
  }

  Future<void> save(Record record) async {
    AppLogger.d('${record.id} の記録情報を保存します。\n${record.toString()}');
    await _appFirebase.writeRecord(record);
  }
}
