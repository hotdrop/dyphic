import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';

class TemperatureRepository {
  const TemperatureRepository._(this._api);

  factory TemperatureRepository.create() {
    return TemperatureRepository._(RecordApi.create());
  }

  final RecordApi _api;

  Future<List<RecordTemperature>> findAll() async {
    return await _api.findTemperatureRecords();
  }
}
