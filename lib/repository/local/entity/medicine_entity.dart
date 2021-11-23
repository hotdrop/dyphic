import 'package:hive/hive.dart';

part 'medicine_entity.g.dart';

@HiveType(typeId: 2)
class MedicineEntity extends HiveObject {
  MedicineEntity({
    required this.id,
    required this.name,
    required this.overview,
    required this.typeIndex,
    required this.memo,
    required this.imagePath,
    required this.order,
  });

  static const String boxName = 'medicine';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final int typeIndex;

  @HiveField(4)
  final String memo;

  @HiveField(5)
  final String imagePath;

  @HiveField(6)
  final int order;
}
