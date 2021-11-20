class RecordTemperatureDoc {
  const RecordTemperatureDoc({
    required this.recordId,
    required this.morningTemperature,
    required this.nightTemperature,
  });

  final int recordId;
  final double morningTemperature;
  final double nightTemperature;
}
