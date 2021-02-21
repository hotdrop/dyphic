import 'package:flutter/material.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:intl/intl.dart';

class Record {
  Record({
    @required this.date,
    @required this.cycle,
    this.morningTemperature,
    this.nightTemperature,
    this.medicines,
    this.conditions,
    this.conditionMemo,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.memo,
  });

  final DateTime date;
  final int cycle;
  final double morningTemperature;
  final double nightTemperature;
  final List<Medicine> medicines;
  final List<String> conditions;
  final String conditionMemo;
  final String breakfast;
  final String lunch;
  final String dinner;
  final String memo;

  static String formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  static int makeRecordId(DateTime date) {
    final str = DateFormat('yyyyMMdd').format(date);
    return int.parse(str);
  }
}
