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

  Future<List<EventRecordDate>> findIds() async {
    return await _recordApi.findEventDates();
  }

  Future<Record> find(DateTime date) async {
    return await _recordApi.find(date);
  }

  Future<void> save(Record record) async {
    await _recordApi.save(record);
  }
}
