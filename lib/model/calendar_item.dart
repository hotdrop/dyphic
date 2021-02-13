import 'package:flutter/material.dart';

class CalendarItem {
  const CalendarItem({
    @required this.id,
    @required this.date,
    @required this.type,
    @required this.name,
    @required this.recordId,
  });

  final int id;
  final DateTime date;
  final int type;
  final String name;
  final int recordId;

  bool typeMedical() => type == 2;
}

enum ItemType { none, hospital, injection }
