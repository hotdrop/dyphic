import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class RecordRepository {
  const RecordRepository._(this._recordApi);

  factory RecordRepository.create({RecordApi argApi}) {
    final api = argApi ?? RecordApi.create();
    return RecordRepository._(api);
  }

  final RecordApi _recordApi;

  Future<List<EventRecord>> findIds() async {
    final recordIds = await _recordApi.findIds();
    AppLogger.i('RecordApiで記録情報のIDを取得しました。id数: ${recordIds.length}');
    return recordIds;
  }

  Future<Record> find(int id) async {
    AppLogger.i('id $id の記録情報を取得します。');
    return await _recordApi.find(id);
  }

  Future<void> save(Record record) async {
    AppLogger.i('id xx の記録情報を保存します。');
    await _recordApi.save(record);
  }

  Future<void> update(Record record) async {
    AppLogger.i('id xx の記録情報を更新します。');
    await _recordApi.update(record);
  }
}
