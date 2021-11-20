import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/event_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recordsProvider = StateNotifierProvider<_RecordsNotifier, List<Record>>((ref) => _RecordsNotifier(ref.read));

class _RecordsNotifier extends StateNotifier<List<Record>> {
  _RecordsNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> onLoad() async {
    final records = await _read(recordRepositoryProvider).findAll(false);
    final events = await _read(eventRepositoryProvider).findAll();
    state = _merge(records, events);
  }

  Future<void> refresh() async {
    final records = await _read(recordRepositoryProvider).findAll(true);
    final events = await _read(eventRepositoryProvider).findAll();
    state = _merge(records, events);
  }

  List<Record> _merge(List<Record> records, List<Event> events) {
    final recordMap = Map.fromIterables(records.map((e) => e.id), records.map((e) => e));

    for (var e in events) {
      if (recordMap.containsKey(e.id)) {
        recordMap[e.id]!.event = e;
      } else {
        final newRecord = Record.create(id: e.id);
        newRecord.event = e;
        recordMap[e.id] = newRecord;
      }
    }

    return recordMap.values.toList();
  }

  ///
  /// 指定したIDの記録情報を最新化する
  /// 例）他の端末で記録情報を見たときに情報が古くなっているとき、このメソッドで最新化する
  ///
  Future<void> reload(int id) async {
    await _read(recordRepositoryProvider).refresh(id);
    await onLoad();
  }
}

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
    required this.morningTemperature,
    required this.nightTemperature,
    required this.medicines,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  }) : date = DyphicID.idToDate(id);

  factory Record.create({required int id}) {
    return Record(
        id: id,
        isWalking: false,
        isToilet: false,
        conditions: [],
        conditionMemo: null,
        morningTemperature: null,
        nightTemperature: null,
        medicines: [],
        breakfast: null,
        lunch: null,
        dinner: null,
        memo: null);
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

  final double? morningTemperature;
  final double? nightTemperature;

  final List<Medicine> medicines;

  final String? memo;

  Event? event;

  static const String _strSeparator = ',';

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

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
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

  bool typeMedical() {
    final type = event?.type;
    if (type == null) {
      return false;
    }
    return type == EventType.hospital;
  }

  bool typeInjection() {
    final type = event?.type;
    if (type == null) {
      return false;
    }
    return type == EventType.injection;
  }
}
