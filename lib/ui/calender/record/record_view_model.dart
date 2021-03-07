import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';
import 'package:flutter/material.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(this._date, this._repository, this._medicineRepository, this._conditionRepository) {
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

  InputRecord _inputRecord;
  double get morningTemperature => _inputRecord.morningTemperature;
  double get nightTemperature => _inputRecord.nightTemperature;
  List<String> get selectConditionNames => _inputRecord.selectConditionNames;
  String get conditionMemo => _inputRecord.conditionMemo;
  List<String> get selectMedicineNames => _inputRecord.selectMedicineNames;
  String get breakfast => _inputRecord.breakfast;
  String get lunch => _inputRecord.lunch;
  String get dinner => _inputRecord.dinner;
  String get memo => _inputRecord.memo;

  List<Medicine> _allMedicines;
  List<String> get allMedicineNames => _allMedicines.map((e) => e.name).toList();

  List<Condition> _allConditions;
  List<String> get allConditionNames => _allConditions.map((e) => e.name).toList();

  ///
  /// 初期処理
  /// コンストラクタでよび、使用元のViewではPageStateでViewModelの利用状態を判断する。
  ///
  Future<void> _init() async {
    final _record = await _repository.find(_date);
    if (_record != null) {
      _inputRecord = InputRecord.create(_record);
    } else {
      _inputRecord = InputRecord.empty(_date);
    }
    _allMedicines = await _medicineRepository.findAll();
    _allConditions = await _conditionRepository.findAll();
    loadSuccess();
  }

  void inputMorningTemperature(double newVal) {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.morningTemperature = newVal;
    notifyListeners();
  }

  void inputNightTemperature(double newVal) {
    AppLogger.d('入力した値は $newVal です');
    _inputRecord.nightTemperature = newVal;
    notifyListeners();
  }

  void changeSelectedCondition(List<String> selectedNamed) {
    AppLogger.d('選択している症状は ${selectedNamed.toString()} 個です');
    _inputRecord.selectConditionNames = selectedNamed;
    notifyListeners();
  }

  void inputConditionMemo(String newVal) {
    _inputRecord.conditionMemo = newVal;
    notifyListeners();
  }

  void changeSelectedMedicine(List<String> selectedNamed) {
    AppLogger.d('選択しているお薬は ${selectedNamed.toString()} です');
    _inputRecord.selectMedicineNames = selectedNamed;
    notifyListeners();
  }

  void inputBreakfast(String newVal) {
    _inputRecord.breakfast = newVal;
    notifyListeners();
  }

  void inputLunch(String newVal) {
    _inputRecord.lunch = newVal;
    notifyListeners();
  }

  void inputDinner(String newVal) {
    _inputRecord.dinner = newVal;
    notifyListeners();
  }

  void inputMemo(String newVal) {
    _inputRecord.memo = newVal;
    notifyListeners();
  }

  Future<bool> save() async {
    final newRecord = _inputRecord.toRecord(_allMedicines, _allConditions);
    try {
      await _repository.save(newRecord);
      return true;
    } catch (e, s) {
      await AppLogger.e('記録情報の保存に失敗しました。', e, s);
      return false;
    }
  }
}

///
/// 入力保持用のクラス
///
class InputRecord {
  InputRecord._({
    @required this.date,
    this.morningTemperature = 0,
    this.nightTemperature = 0,
    this.selectMedicineNames,
    this.selectConditionNames,
    this.conditionMemo = '',
    this.breakfast = '',
    this.lunch = '',
    this.dinner = '',
    this.memo = '',
  });

  factory InputRecord.empty(DateTime date) {
    return InputRecord._(
      date: date,
      selectMedicineNames: [],
      selectConditionNames: [],
    );
  }

  factory InputRecord.create(Record record) {
    return InputRecord._(
      date: record.date,
      morningTemperature: record.morningTemperature,
      nightTemperature: record.nightTemperature,
      selectMedicineNames: record.medicineNames,
      selectConditionNames: record.conditionNames,
      conditionMemo: record.conditionMemo,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      memo: record.memo,
    );
  }

  DateTime date;
  double morningTemperature;
  double nightTemperature;
  List<String> selectMedicineNames;
  List<String> selectConditionNames;
  String conditionMemo;
  String breakfast;
  String lunch;
  String dinner;
  String memo;

  Record toRecord(List<Medicine> allMedicine, List<Condition> allCondition) {
    return Record.createByDate(
      date: date,
      morningTemperature: morningTemperature,
      nightTemperature: nightTemperature,
      medicineNames: selectMedicineNames,
      conditionNames: selectConditionNames,
      conditionMemo: conditionMemo,
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      memo: memo,
    );
  }
}
