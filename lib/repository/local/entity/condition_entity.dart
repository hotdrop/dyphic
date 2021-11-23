import 'package:hive/hive.dart';

part 'condition_entity.g.dart';

@HiveType(typeId: 1)
class ConditionEntity extends HiveObject {
  ConditionEntity({
    required this.id,
    required this.name,
  });

  static const String boxName = 'condition';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;
}
