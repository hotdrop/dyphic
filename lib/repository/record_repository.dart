import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class RecordRepository {
  const RecordRepository._(this._recordApi);

  factory RecordRepository.create() {
    return RecordRepository._(RecordApi.create());
  }

  final RecordApi _recordApi;

  Future<List<RecordOverview>> findEventRecords() async {
    return await _recordApi.findOverviewRecords();
  }

  Future<RecordOverview> findOverview(int id) async {
    return await _recordApi.findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    return await _recordApi.find(id);
  }

  Future<void> save(Record record) async {
    await _recordApi.save(record);
  }
}
