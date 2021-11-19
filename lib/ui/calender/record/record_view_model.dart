import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/base_view_model.dart';

final recordViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _RecordViewModel(ref.read));

class _RecordViewModel extends BaseViewModel {
  _RecordViewModel(this._read);

  final Reader _read;

  late _InputRecord _inputRecord;
  double get morningTemperature => _inputRecord.morningTemperature;
  double get nightTemperature => _inputRecord.nightTemperature;
  Set<int> get selectConditionIds => _inputRecord.selectConditionIds;
  String get conditionMemo => _inputRecord.conditionMemo;
  Set<int> get selectMedicineIds => _inputRecord.selectMedicineIds;
  bool get isWalking => _inputRecord.isWalking;
  bool get isToilet => _inputRecord.isToilet;
  String get breakfast => _inputRecord.breakfast;
  String get lunch => _inputRecord.lunch;
  String get dinner => _inputRecord.dinner;
  String get memo => _inputRecord.memo;

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  Future<void> init(DateTime date) async {
    try {
      final id = DyphicID.makeRecordId(date);
      final _record = await _read(recordRepositoryProvider).find(id);

      _inputRecord = _InputRecord.create(_record);

      await _read(medicineProvider.notifier).refresh();
      await _read(conditionsProvider.notifier).refresh();

      onSuccess();
    } catch (e, s) {
      await AppLogger.e('$dateの記録情報の取得に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputBreakfast(String? newVal) async {
    if (newVal == null) {
      return;
    }
    _inputRecord.breakfast = newVal;
    await _read(recordRepositoryProvider).saveBreakFast(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputLunch(String? newVal) async {
    if (newVal == null) {
      return;
    }
    _inputRecord.lunch = newVal;
    await _read(recordRepositoryProvider).saveLunch(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputDinner(String? newVal) async {
    if (newVal == null) {
      return;
    }
    _inputRecord.dinner = newVal;
    await _read(recordRepositoryProvider).saveDinner(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputMorningTemperature(double newVal) async {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.morningTemperature = newVal;
    await _read(recordRepositoryProvider).saveMorningTemperature(_inputRecord.id, newVal);
    _isUpdate = true;
    // notifyListeners();
  }

  Future<void> inputNightTemperature(double newVal) async {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.nightTemperature = newVal;
    await _read(recordRepositoryProvider).saveNightTemperature(_inputRecord.id, newVal);
    _isUpdate = true;
    // notifyListeners();
  }

  void changeSelectedMedicine(Set<int> selectedIds) {
    AppLogger.d('選択しているお薬は $selectedIds です');
    _inputRecord.selectMedicineIds = selectedIds;
    _isUpdate = true;
  }

  Future<void> saveMedicine() async {
    try {
      final idsStr = _inputRecord.toStringMedicineIds();
      await _read(recordRepositoryProvider).saveMedicineIds(_inputRecord.id, idsStr);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void changeSelectedCondition(Set<int> selectedIds) {
    AppLogger.d('選択している症状は $selectedIds 個です');
    _inputRecord.selectConditionIds = selectedIds;
    _isUpdate = true;
  }

  void inputConditionMemo(String newVal) {
    _inputRecord.conditionMemo = newVal;
    _isUpdate = true;
  }

  Future<void> saveCondition() async {
    final newRecord = _inputRecord.toRecordOverview(_read(conditionsProvider));
    try {
      await _read(recordRepositoryProvider).saveCondition(newRecord);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputIsWalking(bool? isWalking) async {
    _inputRecord.isWalking = isWalking ?? false;
    _isUpdate = true;
  }

  Future<void> inputIsToilet(bool? isToilet) async {
    _inputRecord.isToilet = isToilet ?? false;
    _isUpdate = true;
  }

  void inputMemo(String newVal) {
    _inputRecord.memo = newVal;
  }

  Future<void> saveMemo() async {
    try {
      await _read(recordRepositoryProvider).saveMemo(_inputRecord.id, _inputRecord.memo);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

///
/// 入力保持用のクラス
///
class _InputRecord {
  _InputRecord._({
    required this.id,
    required this.morningTemperature,
    required this.nightTemperature,
    required this.selectMedicineIds,
    required this.selectConditionIds,
    required this.isWalking,
    required this.isToilet,
    required this.conditionMemo,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  });

  factory _InputRecord.create(Record record) {
    final id = DyphicID.makeRecordId(record.date);

    return _InputRecord._(
      id: id,
      morningTemperature: record.morningTemperature ?? 0.0,
      nightTemperature: record.nightTemperature ?? 0.0,
      selectMedicineIds: record.medicines?.map((e) => e.id).toSet() ?? {},
      selectConditionIds: record.conditions?.map((e) => e.id).toSet() ?? {},
      isWalking: record.isWalking ?? false,
      isToilet: record.isToilet ?? false,
      conditionMemo: record.conditionMemo ?? '',
      breakfast: record.breakfast ?? '',
      lunch: record.lunch ?? '',
      dinner: record.dinner ?? '',
      memo: record.memo ?? '',
    );
  }

  int id;
  double morningTemperature;
  double nightTemperature;
  Set<int> selectMedicineIds;
  Set<int> selectConditionIds;
  bool isWalking;
  bool isToilet;
  String conditionMemo;
  String breakfast;
  String lunch;
  String dinner;
  String memo;

  RecordOverview toRecordOverview(List<Condition> allCondition) {
    final selectConditions = allCondition.where((e) => selectConditionIds.contains(e.id)).toList();
    return RecordOverview(recordId: id, isWalking: isWalking, isToilet: isToilet, conditions: selectConditions, conditionMemo: conditionMemo);
  }

  String toStringMedicineIds() {
    if (selectMedicineIds.isEmpty) {
      return '';
    }
    return selectMedicineIds.join(Record.listSeparator);
  }

  Record toRecord(List<Medicine> allMedicine, List<Condition> allCondition) {
    final selectConditions = allCondition.where((e) => selectConditionIds.contains(e.id)).toList();
    final selectMedicines = allMedicine.where((e) => selectMedicineIds.contains(e.id)).toList();

    return Record.create(
      id: id,
      recordOverview: RecordOverview(recordId: id, isWalking: isWalking, isToilet: isToilet, conditions: selectConditions, conditionMemo: conditionMemo),
      recordTemperature: RecordTemperature(recordId: id, morningTemperature: morningTemperature, nightTemperature: nightTemperature),
      recordDetail: RecordDetail(recordId: id, medicines: selectMedicines, breakfast: breakfast, lunch: lunch, dinner: dinner, memo: memo),
    );
  }
}
