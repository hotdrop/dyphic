import 'package:isar/isar.dart';

part 'note_entity.g.dart';

@Collection()
class NoteEntity {
  NoteEntity({
    required this.id,
    required this.title,
    required this.typeValue,
    required this.detail,
  });

  final Id id;
  final String title;
  final int typeValue;
  final String detail;
}
