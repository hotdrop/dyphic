import 'package:isar/isar.dart';

part 'record_entity.g.dart';

@Collection()
class RecordEntity {
  RecordEntity({
    required this.id,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.isWalking,
    required this.isToilet,
    required this.conditionIdsStr,
    required this.conditionMemo,
    required this.morningTemperature,
    required this.nightTemperature,
    required this.medicineIdsStr,
    required this.memo,
    required this.eventTypeIndex,
    required this.eventName,
  });

  final Id id;
  final String? breakfast;
  final String? lunch;
  final String? dinner;
  final bool isWalking;
  final bool isToilet;
  final String? conditionIdsStr;
  final String? conditionMemo;
  final double? morningTemperature;
  final double? nightTemperature;
  final String? medicineIdsStr;
  final String? memo;
  final int? eventTypeIndex;
  final String? eventName;
}
