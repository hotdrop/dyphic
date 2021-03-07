import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///
/// カレンダーで見れる記録情報
/// こちらは全取得するのでなるべく小さくする
///
class RecordOverview {
  RecordOverview._({
    @required this.date,
    @required this.conditionNames,
    @required this.conditionMemo,
  });

  factory RecordOverview.fromRecord(Record record) {
    return RecordOverview._(
      date: record.date,
      conditionNames: record.conditionNames,
      conditionMemo: record.conditionMemo,
    );
  }

  final DateTime date;
  final List<String> conditionNames;
  final String conditionMemo;

  static Map<String, dynamic> toMap(Record record) {
    return <String, dynamic>{
      'date': Record.dateToIdString(record.date),
      'conditions': record.conditionNames.join(Record.nameSeparator),
      'conditionMemo': record.conditionMemo,
    };
  }
}

class Record {
  const Record._(
    this.id,
    this.date,
    this.morningTemperature,
    this.nightTemperature,
    this.medicineNames,
    this.conditionNames,
    this.conditionMemo,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.memo,
  );

  factory Record.createById({
    @required int id,
    double morningTemperature,
    double nightTemperature,
    List<String> medicineNames,
    List<String> conditionNames,
    String conditionMemo,
    String breakfast,
    String lunch,
    String dinner,
    String memo,
  }) {
    return Record._(
      id,
      idToDate(id.toString()),
      morningTemperature,
      nightTemperature,
      medicineNames,
      conditionNames,
      conditionMemo,
      breakfast,
      lunch,
      dinner,
      memo,
    );
  }

  factory Record.createByDate({
    @required DateTime date,
    double morningTemperature,
    double nightTemperature,
    List<String> medicineNames,
    List<String> conditionNames,
    String conditionMemo,
    String breakfast,
    String lunch,
    String dinner,
    String memo,
  }) {
    final id = makeRecordId(date);
    return Record._(
      id,
      date,
      morningTemperature,
      nightTemperature,
      medicineNames,
      conditionNames,
      conditionMemo,
      breakfast,
      lunch,
      dinner,
      memo,
    );
  }

  final int id;
  final DateTime date;
  final double morningTemperature;
  final double nightTemperature;
  final List<String> medicineNames;
  final List<String> conditionNames;
  final String conditionMemo;
  final String breakfast;
  final String lunch;
  final String dinner;
  final String memo;

  static String nameSeparator = ',';

  static int makeRecordId(DateTime date) {
    final str = DateFormat('yyyyMMdd').format(date);
    return int.parse(str);
  }

  static String dateToIdString(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }

  static DateTime idToDate(String id) {
    return DateTime.parse(id.toString());
  }

  @override
  String toString() {
    return '''
    date: $date
    morningTemperature: $morningTemperature
    nightTemperature: $nightTemperature
    medicines: $medicineNames
    conditions: $conditionNames
    conditionMemo: $conditionMemo
    breakfast: $breakfast
    lunch: $lunch
    dinner: $dinner
    memo: $memo
    ''';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': dateToIdString(date),
      'morningTemperature': morningTemperature,
      'nightTemperature': nightTemperature,
      'medicines': medicineNames.join(nameSeparator),
      'conditions': conditionNames.join(nameSeparator),
      'conditionMemo': conditionMemo,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'memo': memo,
    };
  }
}
