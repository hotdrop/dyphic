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

  factory RecordViewModel.create(
    DateTime date, {
    RecordRepository argRecordRepo,
    MedicineRepository argMedicineRepo,
    ConditionRepository argConditionRepo,
  }) {
    final recordRepo = argRecordRepo ?? RecordRepository.create();
    final medicineRepo = argMedicineRepo ?? MedicineRepository.create();
    final conditionRepo = argConditionRepo ?? ConditionRepository.create();
    return RecordViewModel._(date, recordRepo, medicineRepo, conditionRepo);
  }

  final DateTime _date;
  final RecordRepository _repository;
  final MedicineRepository _medicineRepository;
  final ConditionRepository _conditionRepository;

  InputRecord inputRecord;

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
      inputRecord = InputRecord.create(_record);
    } else {
      inputRecord = InputRecord.empty(_date);
    }
    _allMedicines = await _medicineRepository.findAll();
    _allConditions = await _conditionRepository.findAll();
    loadSuccess();
  }

  void inputMorningTemperature(double newVal) {
    inputRecord.morningTemperature = newVal;
  }

  void inputNightTemperature(double newVal) {
    inputRecord.nightTemperature = newVal;
  }

  void changeSelectedCondition(List<String> selectedNamed) {
    AppLogger.d('選択している症状は ${selectedNamed.toString()} 個です');
    inputRecord.selectConditionNames = selectedNamed;
  }

  void inputConditionMemo(String newVal) {
    inputRecord.conditionMemo = newVal;
  }

  void changeSelectedMedicine(List<String> selectedNamed) {
    AppLogger.d('選択しているお薬は ${selectedNamed.toString()} です');
    inputRecord.selectMedicineNames = selectedNamed;
  }

  void inputBreakfast(String newVal) {
    inputRecord.breakfast = newVal;
  }

  void inputLunch(String newVal) {
    inputRecord.lunch = newVal;
  }

  void inputDinner(String newVal) {
    inputRecord.dinner = newVal;
  }

  void inputMemo(String newVal) {
    inputRecord.memo = newVal;
  }

  Future<bool> save() async {
    final newRecord = inputRecord.toRecord(_allMedicines, _allConditions);
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
    this.medicines,
    this.selectMedicineNames,
    this.conditions,
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
      medicines: [],
      selectMedicineNames: [],
      conditions: [],
      selectConditionNames: [],
    );
  }

  factory InputRecord.create(Record record) {
    return InputRecord._(
      date: record.date,
      morningTemperature: record.morningTemperature,
      nightTemperature: record.nightTemperature,
      medicines: record.medicines,
      selectMedicineNames: record.medicines.map((e) => e.name).toList(),
      conditions: record.conditions,
      selectConditionNames: record.conditions.map((e) => e.name).toList(),
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
  List<Medicine> medicines;
  List<String> selectMedicineNames;
  List<Condition> conditions;
  List<String> selectConditionNames;
  String conditionMemo;
  String breakfast;
  String lunch;
  String dinner;
  String memo;

  Record toRecord(List<Medicine> allMedicine, List<Condition> allCondition) {
    final selectMedicines = allMedicine.where((m) => selectMedicineNames.contains(m.name)).toList();
    final selectConditions = allCondition.where((c) => selectConditionNames.contains(c.name)).toList();

    return Record(
      date: date,
      morningTemperature: morningTemperature,
      nightTemperature: nightTemperature,
      medicines: selectMedicines,
      conditions: selectConditions,
      conditionMemo: conditionMemo,
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      memo: memo,
    );
  }
}
