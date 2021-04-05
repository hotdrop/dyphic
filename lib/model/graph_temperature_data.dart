import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';

class GraphTemperatureData {
  const GraphTemperatureData._(this.year, this.month, this.day, this.morning, this.night);

  factory GraphTemperatureData.create(RecordTemperature rt) {
    String date = rt.recordId.toString();
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    return GraphTemperatureData._(year, month, day, rt.morningTemperature, rt.nightTemperature);
  }

  final int year;
  final int month;
  final int day;
  final double morning;
  final double night;
}
