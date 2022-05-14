class GraphTemperature {
  const GraphTemperature._(this.dateAt, this.morning, this.night);

  factory GraphTemperature.create({
    required DateTime dateAt,
    required double morningTemperature,
    required double nightTemperature,
  }) {
    return GraphTemperature._(dateAt, morningTemperature, nightTemperature);
  }

  final DateTime dateAt;
  final double morning;
  final double night;

  int get year => dateAt.year;
  int get month => dateAt.month;
  int get day => dateAt.day;
}
