import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class RecordRepository {
  const RecordRepository._(this._recordApi);

  factory RecordRepository.create() {
    return RecordRepository._(RecordApi.create());
  }

  final RecordApi _recordApi;

  Future<List<RecordOverview>> findEventRecords() async {
    return await _recordApi.findEventRecords();
  }

  Future<Record> find(DateTime date) async {
    final id = Record.makeRecordId(date);
    return await _recordApi.find(id);
  }

  Future<void> save(Record record) async {
    await _recordApi.save(record);
  }
}
