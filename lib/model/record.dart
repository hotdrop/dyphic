import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recordsProvider = StateNotifierProvider<_RecordsNotifier, List<Record>>((ref) => _RecordsNotifier(ref.read));

class _RecordsNotifier extends StateNotifier<List<Record>> {
  _RecordsNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> onLoad() async {
    state = await _read(recordRepositoryProvider).findAll(false);
  }

  Future<void> refresh() async {
    state = await _read(recordRepositoryProvider).findAll(true);
  }

  ///
  /// 指定したIDの記録情報を最新化する
  ///
  Future<void> reload(int id) async {
    await _read(recordRepositoryProvider).refresh(id);
    state = await _read(recordRepositoryProvider).findAll(false);
  }

  ///
  /// 指定したIDの記録情報のみを更新する
  ///
  Future<void> update(int id) async {
    final newRecord = await _read(recordRepositoryProvider).find(id);
    if (newRecord == null) {
      return;
    }
    final tmp = state;
    tmp[tmp.indexWhere((e) => e.id == id)] = newRecord;
    state = tmp;
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

  static const String _strSeparator = ',';

  static List<Condition> toConditions(List<Condition> conditions, String? idsStr) {
    if (idsStr == null) {
      return [];
    }
    final ids = _splitIds(idsStr);
    return conditions.where((e) => ids.contains(e.id)).toList();
  }

  String toConditionIdsStr(List<Condition> conditions) {
    return conditions.isEmpty ? '' : conditions.map((c) => c.id).join(_strSeparator);
  }

  String toMedicineIdsStr(List<Medicine> medicines) {
    return medicines.isEmpty ? '' : medicines.map((c) => c.id).join(_strSeparator);
  }

  static String setToMedicineIdsStr(Set<int> medicines) {
    return medicines.isEmpty ? '' : medicines.join(_strSeparator);
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
}
