import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class RecordRepository {
  const RecordRepository._(this._recordApi);

  factory RecordRepository.create() {
    return RecordRepository._(RecordApi.create());
  }

  final RecordApi _recordApi;

  Future<List<EventRecord>> findEventRecords() async {
    return await _recordApi.findEventRecords();
  }

  Future<Record> find(DateTime date) async {
    return await _recordApi.find(date);
  }

  Future<void> save(Record record) async {
    await _recordApi.save(record);
  }
}
