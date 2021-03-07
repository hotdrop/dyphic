import 'package:dyphic/model/dyphic_id.dart';
import 'package:flutter/material.dart';

///
/// カレンダーで見れる記録情報
/// このアプリは体調情報がメインなのでこのクラスで保持するのは体調情報のみ
///
class RecordOverview {
  RecordOverview({
    @required this.recordId,
    @required this.conditionNames,
    @required this.conditionMemo,
  });

  factory RecordOverview.fromRecord(Record record) {
    return RecordOverview(
      recordId: record.id,
      conditionNames: record.conditionNames,
      conditionMemo: record.conditionMemo,
    );
  }

  final int recordId;
  final List<String> conditionNames;
  final String conditionMemo;

  static Map<String, dynamic> toMap(Record record) {
    return <String, dynamic>{
      'date': DyphicID.dateToIdString(record.date),
      'conditions': record.conditionNames.join(Record.nameSeparator),
      'conditionMemo': record.conditionMemo,
    };
  }
}

///
/// 記録情報のうち体温を保持するクラス
///
class RecordTemperature {
  const RecordTemperature({
    @required this.recordId,
    this.morningTemperature,
    this.nightTemperature,
  });

  final int recordId;
  final double morningTemperature;
  final double nightTemperature;
}

///
/// 記録情報を保持する
///
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
    RecordOverview recordOverview,
    RecordTemperature recordTemperature,
    List<String> medicineNames,
    String breakfast,
    String lunch,
    String dinner,
    String memo,
  }) {
    final morningT = recordTemperature?.morningTemperature ?? 0;
    final nightT = recordTemperature?.nightTemperature ?? 0;
    final cNames = recordOverview?.conditionNames ?? [];
    final cMemo = recordOverview?.conditionMemo ?? '';
    return Record._(id, DyphicID.idToDate(id), morningT, nightT, medicineNames, cNames, cMemo, breakfast, lunch, dinner, memo);
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
      'date': DyphicID.dateToIdString(date),
      'medicines': medicineNames.join(nameSeparator),
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'memo': memo,
    };
  }
}
