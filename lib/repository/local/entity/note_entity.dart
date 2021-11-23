import 'package:hive/hive.dart';

part 'note_entity.g.dart';

@HiveType(typeId: 5)
class NoteEntity extends HiveObject {
  NoteEntity({
    required this.id,
    required this.title,
    required this.typeValue,
    required this.detail,
  });

  static const String boxName = 'note';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int typeValue;

  @HiveField(3)
  final String detail;
}
