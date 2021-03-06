import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/graph_temperature_data.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/temperature_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class TemperatureViewModel extends NotifierViewModel {
  TemperatureViewModel._(this._repository) {
    _init();
  }

  factory TemperatureViewModel.create() {
    return TemperatureViewModel._(TemperatureRepository.create());
  }

  final TemperatureRepository _repository;

  late List<GraphTemperatureData> _temperatures;
  List<GraphTemperatureData> get mornings => _temperatures.where((t) => t.morning > 0).toList();
  List<GraphTemperatureData> get nights => _temperatures.where((t) => t.night > 0).toList();

  Future<void> _init() async {
    final List<RecordTemperature> results = await _repository.findAll();

    final List<GraphTemperatureData> temperatureDatas = results
        .where((t) => t.morningTemperature > 0 || t.nightTemperature > 0)
        .map((t) => GraphTemperatureData.create(t))
        .toList();

    // 当月と前月だけグラフに出す
    final nowDate = DateTime.now();
    final nowYear = nowDate.year;
    final nowMonth = nowDate.month;

    final prevDate = DateTime(nowYear, nowMonth - 1, nowDate.day);
    final prevYear = prevDate.year;
    final prevMonth = prevDate.month;
    AppLogger.d('$prevYear年$prevMonth月から$nowYear年$nowMonth月まで取得');

    _temperatures = temperatureDatas
        .where((t) => (t.year == prevYear && t.month == prevMonth) || (t.year == nowYear && t.month == nowMonth))
        .toList();

    loadSuccess();
  }
}
