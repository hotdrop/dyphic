import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/base_view_model.dart';

final recordViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _RecordViewModel(ref.read));

class _RecordViewModel extends BaseViewModel {
  _RecordViewModel(this._read);

  final Reader _read;

  late int _id;

  Set<int> _selectConditionIds = {};
  bool _inputIsWalking = false;
  bool _inputIsToilet = false;
  String _inputConditionMemo = '';
  Set<int> _selectMedicineIds = {};
  String _memo = '';

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  Future<void> init(int id) async {
    _id = id;
    onSuccess();
  }

  Future<void> update() async {
    await _read(recordsProvider.notifier).update(_id);
  }

  Future<void> inputBreakfast(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordsProvider.notifier).saveBreakFast(_id, newVal);
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      onError('朝食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputLunch(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordsProvider.notifier).saveLunch(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      onError('昼食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputDinner(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordsProvider.notifier).saveDinner(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      onError('夕食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputMorningTemperature(double newVal) async {
    try {
      await _read(recordsProvider.notifier).saveMorningTemperature(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
      onError('朝の体温の保存に失敗しました。 $e');
    }
  }

  Future<void> inputNightTemperature(double newVal) async {
    try {
      await _read(recordsProvider.notifier).saveNightTemperature(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('夜の体温の保存に失敗しました。', e, s);
      onError('夜の体温の保存に失敗しました。 $e');
    }
  }

  // ここから体調情報

  void changeSelectedCondition(Set<int> selectedIds) {
    AppLogger.d('選択している症状は $selectedIds 個です');
    _selectConditionIds = selectedIds;
  }

  void inputIsWalking(bool? isWalking) {
    _inputIsWalking = isWalking ?? false;
  }

  void inputIsToilet(bool? isToilet) {
    _inputIsToilet = isToilet ?? false;
  }

  void inputConditionMemo(String newVal) {
    _inputConditionMemo = newVal;
  }

  Future<void> saveCondition() async {
    try {
      final newRecord = _createOnlyCondition(_id);
      await _read(recordsProvider.notifier).saveCondition(newRecord);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      onError('体調情報の保存に失敗しました。 $e');
    }
  }

  Record _createOnlyCondition(int id) {
    final allConditions = _read(conditionsProvider);
    final conditions = allConditions.where((e) => _selectConditionIds.contains(e.id)).toList();
    return Record(
      id: id,
      isWalking: _inputIsWalking,
      isToilet: _inputIsToilet,
      conditions: conditions,
      conditionMemo: _inputConditionMemo,
      morningTemperature: null,
      nightTemperature: null,
      medicines: [],
      breakfast: null,
      lunch: null,
      dinner: null,
      memo: null,
    );
  }

  // ここからお薬情報

  void changeSelectedMedicine(Set<int> selectedIds) {
    AppLogger.d('選択しているお薬は $selectedIds です');
    _selectMedicineIds = selectedIds;
  }

  Future<void> saveMedicine() async {
    try {
      final idsStr = Record.setToMedicineIdsStr(_selectMedicineIds);
      await _read(recordsProvider.notifier).saveMedicineIds(_id, idsStr);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      onError('選択したお薬の保存に失敗しました。 $e');
    }
  }

  // ここからメモ情報
  void inputMemo(String newVal) {
    _memo = newVal;
  }

  Future<void> saveMemo() async {
    try {
      await _read(recordsProvider.notifier).saveMemo(_id, _memo);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      onError('メモの保存に失敗しました。 $e');
    }
  }
}

// ///
// /// 入力保持用のクラス
// ///
// class _InputRecord {
//   _InputRecord._({
//     required this.id,
//     required this.morningTemperature,
//     required this.nightTemperature,
//     required this.selectMedicineIds,
//     required this.selectConditionIds,
//     required this.isWalking,
//     required this.isToilet,
//     required this.conditionMemo,
//     required this.breakfast,
//     required this.lunch,
//     required this.dinner,
//     required this.memo,
//   });

//   factory _InputRecord.create(Record record) {
//     final id = DyphicID.makeRecordId(record.date);

//     return _InputRecord._(
//       id: id,
//       morningTemperature: record.morningTemperature ?? 0.0,
//       nightTemperature: record.nightTemperature ?? 0.0,
//       selectMedicineIds: record.medicines.map((e) => e.id).toSet(),
//       selectConditionIds: record.conditions.map((e) => e.id).toSet(),
//       isWalking: record.isWalking,
//       isToilet: record.isToilet,
//       conditionMemo: record.conditionMemo ?? '',
//       breakfast: record.breakfast ?? '',
//       lunch: record.lunch ?? '',
//       dinner: record.dinner ?? '',
//       memo: record.memo ?? '',
//     );
//   }

//   int id;
//   double morningTemperature;
//   double nightTemperature;
//   Set<int> selectMedicineIds;
//   Set<int> selectConditionIds;
//   bool isWalking;
//   bool isToilet;
//   String conditionMemo;
//   String breakfast;
//   String lunch;
//   String dinner;
//   String memo;

//   Record toRecordOverview(List<Condition> allCondition) {
//     final selectConditions = allCondition.where((e) => selectConditionIds.contains(e.id)).toList();
//     return Record(
//       id: id,
//       isWalking: isWalking,
//       isToilet: isToilet,
//       conditions: selectConditions,
//       conditionMemo: conditionMemo,
//       breakfast: '',
//       dinner: '',
//       lunch: '',
//       medicines: [],
//       memo: '',
//       morningTemperature: null,
//       nightTemperature: null,
//     );
//   }

//   String toStringMedicineIds() {
//     if (selectMedicineIds.isEmpty) {
//       return '';
//     }
//     return selectMedicineIds.join(Record.listSeparator);
//   }

//   Record toRecord(List<Medicine> allMedicine, List<Condition> allCondition) {
//     final selectConditions = allCondition.where((e) => selectConditionIds.contains(e.id)).toList();
//     final selectMedicines = allMedicine.where((e) => selectMedicineIds.contains(e.id)).toList();

//     return Record.create(
//       id: id,
//       recordOverview: RecordOverview(recordId: id, isWalking: isWalking, isToilet: isToilet, conditions: selectConditions, conditionMemo: conditionMemo),
//       recordTemperature: RecordTemperature(recordId: id, morningTemperature: morningTemperature, nightTemperature: nightTemperature),
//       recordDetail: RecordDetail(recordId: id, medicines: selectMedicines, breakfast: breakfast, lunch: lunch, dinner: dinner, memo: memo),
//     );
//   }
// }
