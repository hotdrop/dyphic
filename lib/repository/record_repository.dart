import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class RecordRepository {
  const RecordRepository._(this._api);

  factory RecordRepository.create() {
    return RecordRepository._(RecordApi.create());
  }

  final RecordApi _api;

  Future<List<RecordOverview>> findEventRecords() async {
    return await _api.findOverviewRecords();
  }

  Future<RecordOverview?> findOverview(int id) async {
    return await _api.findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    return await _api.find(id);
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    await _api.saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    await _api.saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    await _api.saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    await _api.saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    await _api.saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(RecordOverview overview) async {
    await _api.saveCondition(overview);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    // ここでIDを列挙する？
    await _api.saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    await _api.saveMemo(recordId, memo);
  }
}
