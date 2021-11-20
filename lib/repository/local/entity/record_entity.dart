import 'package:hive/hive.dart';

part 'record_entity.g.dart';

@HiveType(typeId: 4)
class RecordEntity extends HiveObject {
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
  });

  static const String boxName = 'record';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? breakfast;

  @HiveField(2)
  final String? lunch;

  @HiveField(3)
  final String? dinner;

  @HiveField(4)
  final bool isWalking;

  @HiveField(5)
  final bool isToilet;

  @HiveField(6)
  final String? conditionIdsStr;

  @HiveField(7)
  final String? conditionMemo;

  @HiveField(8)
  final double? morningTemperature;

  @HiveField(9)
  final double? nightTemperature;

  @HiveField(10)
  final String? medicineIdsStr;

  @HiveField(11)
  final String? memo;
}
