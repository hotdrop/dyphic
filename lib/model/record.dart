import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';

///
/// 記録情報を保持する
///
class Record {
  const Record._(
    this.id,
    this.date,
    this.overview,
    this.temperature,
    this.detail,
  );

  factory Record.create({
    required int id,
    RecordOverview? recordOverview,
    RecordTemperature? recordTemperature,
    RecordDetail? recordDetail,
  }) {
    return Record._(id, DyphicID.idToDate(id), recordOverview, recordTemperature, recordDetail);
  }

  final int id;
  final DateTime date;
  final RecordOverview? overview;
  final RecordTemperature? temperature;
  final RecordDetail? detail;

  bool? get isWalking => overview?.isWalking;
  List<Condition>? get conditions => overview?.conditions;
  String? get conditionMemo => overview?.conditionMemo;
  double? get morningTemperature => temperature?.morningTemperature;
  double? get nightTemperature => temperature?.nightTemperature;
  List<Medicine>? get medicines => detail?.medicines;
  String? get breakfast => detail?.breakfast;
  String? get lunch => detail?.lunch;
  String? get dinner => detail?.dinner;
  String? get memo => detail?.memo;

  static String listSeparator = ',';

  @override
  String toString() {
    return '''
    date: $date
    ${overview?.toString() ?? 'overview: null'}
    ${temperature?.toString() ?? 'temperature: null'}
    ${detail?.toString() ?? 'detail: null'}
    ''';
  }
}

///
/// 記録情報（概要）
/// カレンダー表示時に各日付に紐付ける情報で、カレンダーではこのクラスにあるもののみ即閲覧可能
/// このアプリは体調情報がメインなので、体調情報を保持している
///
class RecordOverview {
  const RecordOverview({
    required this.recordId,
    required this.isWalking,
    required this.conditions,
    required this.conditionMemo,
  });

  final int recordId;
  final bool isWalking;
  final List<Condition> conditions;
  final String conditionMemo;

  String toStringConditionIds() {
    if (conditions.isEmpty) {
      return '';
    }
    return conditions.map((c) => c.id).join(Record.listSeparator);
  }

  String toStringConditionNames() {
    if (conditions.isEmpty) {
      return '';
    }
    return conditions.map((c) => c.name).join('${Record.listSeparator} ');
  }

  @override
  String toString() {
    return '''
    walking: $isWalking
    conditions: ${conditions.map((c) => c.name)}
    conditionMemo: $conditionMemo
    ''';
  }
}

///
/// 記録情報（体温）
/// 体温はグラフにしたいので別で保持している
///
class RecordTemperature {
  const RecordTemperature({
    required this.recordId,
    required this.morningTemperature,
    required this.nightTemperature,
  });

  final int recordId;
  final double morningTemperature;
  final double nightTemperature;

  @override
  String toString() {
    return '''
    morningTemperature: $morningTemperature
    nightTemperature: $nightTemperature
    ''';
  }
}

///
/// 記録情報（詳細）
/// 体調と体温以外の記録情報
///
class RecordDetail {
  const RecordDetail({
    required this.recordId,
    required this.medicines,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  });

  final int recordId;
  final List<Medicine> medicines;
  final String breakfast;
  final String lunch;
  final String dinner;
  final String memo;

  @override
  String toString() {
    return '''
    medicines: ${medicines.map((m) => m.name)}
    breakfast: $breakfast
    lunch: $lunch
    dinner: $dinner
    memo: $memo
    ''';
  }
}
