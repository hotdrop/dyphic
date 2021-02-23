import 'package:dyphic/model/condition.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:intl/intl.dart';

class Record {
  Record({
    @required this.date,
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
  final double morningTemperature;
  final double nightTemperature;
  final List<Medicine> medicines;
  final List<Condition> conditions;
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

  @override
  String toString() {
    return '''
    date: $date
    morningTemperature: $morningTemperature
    nightTemperature: $nightTemperature
    medicines: ${medicines.map((e) => e.name).toList()}
    conditions: ${conditions.map((e) => e.name).toList()}
    conditionMemo: $conditionMemo
    breakfast: $breakfast
    lunch: $lunch
    dinner: $dinner
    memo: $memo
    ''';
  }
}
