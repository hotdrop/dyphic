import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:intl/intl.dart';

///
/// 記録情報のモデルクラス
///
class Record {
  Record({
    required this.id,
    required this.isWalking,
    required this.isToilet,
    required this.conditions,
    required this.conditionMemo,
    required this.eventType,
    required this.eventName,
    required this.morningTemperature,
    required this.nightTemperature,
    required this.medicines,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  }) : date = DyphicID.idToDate(id);

  factory Record.createEmptyForDate(DateTime idDate) {
    final id = DyphicID.dateToId(idDate);
    return Record.createEmpty(id);
  }

  factory Record.createEmpty(int id) {
    return Record(
      id: id,
      isWalking: false,
      isToilet: false,
      conditions: [],
      conditionMemo: null,
      eventType: EventType.none,
      eventName: null,
      morningTemperature: null,
      nightTemperature: null,
      medicines: [],
      breakfast: null,
      lunch: null,
      dinner: null,
      memo: null,
    );
  }

  factory Record.condition({
    required int id,
    required List<Condition> conditions,
    required bool isWalking,
    required bool isToilet,
    required String memo,
  }) {
    return Record(
      id: id,
      isWalking: isWalking,
      isToilet: isToilet,
      conditions: conditions,
      conditionMemo: memo,
      eventType: EventType.none,
      eventName: null,
      morningTemperature: null,
      nightTemperature: null,
      medicines: [],
      breakfast: null,
      lunch: null,
      dinner: null,
      memo: null,
    );
  }

  final int id;
  final DateTime date;

  final String? breakfast;
  final String? lunch;
  final String? dinner;

  final bool isWalking;
  final bool isToilet;
  final List<Condition> conditions;
  final String? conditionMemo;

  final EventType eventType;
  final String? eventName;

  final double? morningTemperature;
  final double? nightTemperature;

  final List<Medicine> medicines;

  final String? memo;

  static const String _strSeparator = ',';

  String showFormatDate() {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  bool isSameDay(DateTime targetAt) {
    return date.year == targetAt.year && date.month == targetAt.month && date.day == targetAt.day;
  }

  bool notRegister() {
    return breakfast == null && lunch == null && dinner == null && conditions.isEmpty && conditionMemo == null;
  }

  static List<Condition> toConditions(List<Condition> conditions, String? idsStr) {
    if (idsStr == null) {
      return [];
    }
    final ids = _splitIds(idsStr);
    return conditions.where((e) => ids.contains(e.id)).toList();
  }

  String toConditionIdsStr() {
    return conditions.isEmpty ? '' : conditions.map((c) => c.id).join(_strSeparator);
  }

  String toMedicineIdsStr() {
    return medicines.isEmpty ? '' : medicines.map((c) => c.id).join(_strSeparator);
  }

  static String setToMedicineIdsStr(Set<int> medicinesSet) {
    return medicinesSet.isEmpty ? '' : medicinesSet.join(_strSeparator);
  }

  String toConditionNames() {
    return conditions.isEmpty ? '' : conditions.map((c) => c.name).join('$_strSeparator ');
  }

  static List<Medicine> toMedicines(List<Medicine> medicines, String? idsStr) {
    if (idsStr == null) {
      return [];
    }
    final ids = _splitIds(idsStr);
    return medicines.where((e) => ids.contains(e.id)).toList();
  }

  static List<int> _splitIds(String nStr) {
    if (nStr.isEmpty) {
      return [];
    }
    if (nStr.contains(_strSeparator)) {
      return nStr.split(_strSeparator).map((id) => int.parse(id)).toList();
    } else {
      return [int.parse(nStr)];
    }
  }

  bool get typeMedical => eventType == EventType.hospital;

  bool get typeInjection => eventType == EventType.injection;

  static EventType toEventType(int? index) {
    if (index == EventType.hospital.index) {
      return EventType.hospital;
    } else if (index == EventType.injection.index) {
      return EventType.injection;
    } else {
      return EventType.none;
    }
  }
}

enum EventType { none, hospital, injection }
