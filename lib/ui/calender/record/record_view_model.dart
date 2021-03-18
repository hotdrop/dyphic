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
  String get breakfast => _inputRecord.breakfast;
  String get lunch => _inputRecord.lunch;
  String get dinner => _inputRecord.dinner;
  String get memo => _inputRecord.memo;

  late List<Medicine> _allMedicines;
  List<Medicine> get allMedicines => _allMedicines;

  late List<Condition> _allConditions;
  List<Condition> get allConditions => _allConditions;

  bool _isEditNotSaved = false;
  bool get isEditNotSaved => _isEditNotSaved;

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

  void inputBreakfast(String newVal) {
    _inputRecord.breakfast = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputLunch(String newVal) {
    _inputRecord.lunch = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputDinner(String newVal) {
    _inputRecord.dinner = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputMorningTemperature(double newVal) {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.morningTemperature = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputNightTemperature(double newVal) {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.nightTemperature = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void changeSelectedCondition(Set<int> selectedIds) {
    AppLogger.d('選択している症状は $selectedIds 個です');
    _inputRecord.selectConditionIds = selectedIds;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputConditionMemo(String newVal) {
    _inputRecord.conditionMemo = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void changeSelectedMedicine(Set<int> selectedIds) {
    AppLogger.d('選択しているお薬は $selectedIds です');
    _inputRecord.selectMedicineIds = selectedIds;
    _isEditNotSaved = true;
    notifyListeners();
  }

  void inputMemo(String newVal) {
    _inputRecord.memo = newVal;
    _isEditNotSaved = true;
    notifyListeners();
  }

  Future<bool> save() async {
    final newRecord = _inputRecord.toRecord(_allMedicines, _allConditions);
    try {
      await _repository.save(newRecord);
      _isEditNotSaved = false;
      return true;
    } catch (e, s) {
      await AppLogger.e('記録情報の保存に失敗しました。', e, s);
      return false;
    }
  }

  void isSuccessSaved() {
    _isUpdate = true;
  }
}

///
/// 入力保持用のクラス
///
class InputRecord {
  InputRecord._({
    required this.date,
    required this.morningTemperature,
    required this.nightTemperature,
    required this.selectMedicineIds,
    required this.selectConditionIds,
    required this.conditionMemo,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  });

  factory InputRecord.create(Record record) {
    return InputRecord._(
      date: record.date,
      morningTemperature: record.morningTemperature ?? 0.0,
      nightTemperature: record.nightTemperature ?? 0.0,
      selectMedicineIds: record.medicines?.map((e) => e.id).toSet() ?? {},
      selectConditionIds: record.conditions?.map((e) => e.id).toSet() ?? {},
      conditionMemo: record.conditionMemo ?? '',
      breakfast: record.breakfast ?? '',
      lunch: record.lunch ?? '',
      dinner: record.dinner ?? '',
      memo: record.memo ?? '',
    );
  }

  DateTime date;
  double morningTemperature;
  double nightTemperature;
  Set<int> selectMedicineIds;
  Set<int> selectConditionIds;
  String conditionMemo;
  String breakfast;
  String lunch;
  String dinner;
  String memo;

  Record toRecord(List<Medicine> allMedicine, List<Condition> allCondition) {
    final id = DyphicID.makeRecordId(date);

    final selectConditions = allCondition.where((e) => selectConditionIds.contains(e.id)).toList();
    final selectMedicines = allMedicine.where((e) => selectMedicineIds.contains(e.id)).toList();

    return Record.create(
      id: id,
      recordOverview: RecordOverview(recordId: id, conditions: selectConditions, conditionMemo: conditionMemo),
      recordTemperature: RecordTemperature(recordId: id, morningTemperature: morningTemperature, nightTemperature: nightTemperature),
      recordDetail: RecordDetail(recordId: id, medicines: selectMedicines, breakfast: breakfast, lunch: lunch, dinner: dinner, memo: memo),
    );
  }
}
