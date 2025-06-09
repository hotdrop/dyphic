import 'package:isar/isar.dart';

part 'medicine_entity.g.dart';

@Collection()
class MedicineEntity {
  MedicineEntity({
    required this.id,
    required this.name,
    required this.overview,
    required this.typeIndex,
    required this.memo,
    required this.order,
  });

  final Id id;
  final String name;
  final String overview;
  final int typeIndex;
  final String memo;
  final int order;
}
