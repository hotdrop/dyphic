import 'package:isar/isar.dart';

part 'condition_entity.g.dart';

@Collection()
class ConditionEntity {
  ConditionEntity({
    required this.id,
    required this.name,
  });

  final Id id;
  final String name;
}
