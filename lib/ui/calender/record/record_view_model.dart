import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(
    this._date,
    this._repository,
    this._medicineRepository,
    this._conditionRepository,
  ) {
    _init();
  }

  factory RecordViewModel.create(DateTime date) {
    return RecordViewModel._(
      date,
      RecordRepository.create(),
      MedicineRepository.create(),
      ConditionRepository.create(),
    );
  }

  final DateTime _date;
  final RecordRepository _repository;
  final MedicineRepository _medicineRepository;
  final ConditionRepository _conditionRepository;

  late InputRecord _inputRecord;
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

  late List<Medicine> _allMedicines;
  List<Medicine> get allMedicines => _allMedicines;

  late List<Condition> _allConditions;
  List<Condition> get allConditions => _allConditions;

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  ///
  /// 初期処理
  /// コンストラクタでよび、使用元のViewではPageStateでViewModelの利用状態を判断する。
  ///
  Future<void> _init() async {
    final id = DyphicID.makeRecordId(_date);
    final _record = await _repository.find(id);

    _inputRecord = InputRecord.create(_record);

    _allMedicines = await _medicineRepository.findAll();
    _allConditions = await _conditionRepository.findAll();
    loadSuccess();
  }

  Future<void> inputBreakfast(String newVal) async {
    _inputRecord.breakfast = newVal;
    await _repository.saveBreakFast(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputLunch(String newVal) async {
    _inputRecord.lunch = newVal;
    await _repository.saveLunch(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputDinner(String newVal) async {
    _inputRecord.dinner = newVal;
    await _repository.saveDinner(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputMorningTemperature(double newVal) async {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.morningTemperature = newVal;
    await _repository.saveMorningTemperature(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  Future<void> inputNightTemperature(double newVal) async {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.nightTemperature = newVal;
    await _repository.saveNightTemperature(_inputRecord.id, newVal);
    _isUpdate = true;
    notifyListeners();
  }

  void changeSelectedMedicine(Set<int> selectedIds) {
    AppLogger.d('選択しているお薬は $selectedIds です');
    _inputRecord.selectMedicineIds = selectedIds;
    notifyListeners();
  }

  Future<bool> saveMedicine() async {
    try {
      final idsStr = _inputRecord.toStringMedicineIds();
      await _repository.saveMedicineIds(_inputRecord.id, idsStr);
      _isUpdate = true;
      return true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      return false;
    }
  }

  void changeSelectedCondition(Set<int> selectedIds) {
    AppLogger.d('選択している症状は $selectedIds 個です');
    _inputRecord.selectConditionIds = selectedIds;
    notifyListeners();
  }

  void inputConditionMemo(String newVal) {
    _inputRecord.conditionMemo = newVal;
  }

  Future<bool> saveCondition() async {
    final newRecord = _inputRecord.toRecordOverview(_allConditions);
    try {
      await _repository.saveCondition(newRecord);
      _isUpdate = true;
      return true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      return false;
    }
  }

  Future<void> inputIsWalking(bool? isWalking) async {
    _inputRecord.isWalking = isWalking ?? false;
    notifyListeners();
  }

  Future<void> inputIsToilet(bool? isToilet) async {
    _inputRecord.isToilet = isToilet ?? false;
    notifyListeners();
  }

  void inputMemo(String newVal) {
    _inputRecord.memo = newVal;
  }

  Future<bool> saveMemo() async {
    try {
      await _repository.saveMemo(_inputRecord.id, _inputRecord.memo);
      _isUpdate = true;
      return true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      return false;
    }
  }
}

///
/// 入力保持用のクラス
///
class InputRecord {
  InputRecord._({
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

  factory InputRecord.create(Record record) {
    final id = DyphicID.makeRecordId(record.date);
    return InputRecord._(
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
    return RecordOverview(
        recordId: id, isWalking: isWalking, isToilet: isToilet, conditions: selectConditions, conditionMemo: conditionMemo);
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
      recordOverview: RecordOverview(
          recordId: id, isWalking: isWalking, isToilet: isToilet, conditions: selectConditions, conditionMemo: conditionMemo),
      recordTemperature:
          RecordTemperature(recordId: id, morningTemperature: morningTemperature, nightTemperature: nightTemperature),
      recordDetail:
          RecordDetail(recordId: id, medicines: selectMedicines, breakfast: breakfast, lunch: lunch, dinner: dinner, memo: memo),
    );
  }
}
