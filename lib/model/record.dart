import 'package:flutter/material.dart';
import 'package:dyphic/model/medicine.dart';

class Record {
  Record({
    @required this.id,
    @required this.date,
    @required this.cycle,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.medicine,
    this.morningTemperature,
    this.dailyTemperature,
    this.condition,
    this.memo,
  });

  final int id;
  final DateTime date;
  final int cycle;
  final String breakfast;
  final String lunch;
  final String dinner;
  final List<Medicine> medicine;
  final double morningTemperature;
  final double dailyTemperature;
  final List<String> condition;
  final String memo;

  String formatDate() {
    return '${date.year}年${date.month}月${date.day}日';
  }
}
