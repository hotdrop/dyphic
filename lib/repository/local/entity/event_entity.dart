import 'package:hive/hive.dart';

part 'event_entity.g.dart';

@HiveType(typeId: 3)
class EventEntity extends HiveObject {
  EventEntity({
    required this.id,
    required this.type,
    required this.name,
  });

  static const String boxName = 'event';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int type;

  @HiveField(2)
  final String name;
}
