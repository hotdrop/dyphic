import 'package:dyphic/model/note.dart';
import 'package:flutter/material.dart';

class NoteTypeIcon extends StatelessWidget {
  const NoteTypeIcon(this.type, {Key? key}) : super(key: key);

  factory NoteTypeIcon.createNote(Note note) {
    final type = NoteType.values.where((v) => v.typeValue == note.typeValue).first;
    return NoteTypeIcon(type);
  }

  final NoteType type;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: type.color,
      child: Icon(type.iconData, color: Colors.white),
    );
  }
}
