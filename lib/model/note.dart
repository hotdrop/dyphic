import 'package:flutter/material.dart';

class Note {
  const Note({
    required this.id,
    required this.typeValue,
    required this.title,
    required this.detail,
  });

  factory Note.createEmpty(int id) {
    return Note(id: id, typeValue: 1, title: '', detail: '');
  }

  final int id;
  final int typeValue;
  final String title;
  final String detail;
}

class NoteType {
  const NoteType(this.typeValue, this.iconData, this.color);

  factory NoteType.fromValue(int typeValue) {
    return values.firstWhere((e) => e.typeValue == typeValue, orElse: () => NoteType(1, Icons.local_drink, Colors.blue[300]));
  }

  final int typeValue;
  final IconData iconData;
  final Color? color;

  static List<NoteType> get values => [
        NoteType(1, Icons.local_drink, Colors.blue[300]),
        NoteType(2, Icons.medical_services_outlined, Colors.green[300]),
        NoteType(3, Icons.local_hospital, Colors.red[300]),
        NoteType(4, Icons.sticky_note_2_outlined, Colors.purple[300]),
      ];
}
