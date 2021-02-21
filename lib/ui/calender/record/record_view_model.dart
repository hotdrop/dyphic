import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(this.date, this._repository, this._medicineRepository, this._conditionRepository) {
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

  final DateTime date;
  final RecordRepository _repository;
  final MedicineRepository _medicineRepository;
  final ConditionRepository _conditionRepository;

  Record _record;
  Record get record => _record;

  List<Medicine> _allMedicines;
  List<String> get allMedicineNames => _allMedicines.map((e) => e.name).toList();
  List<String> get takenMedicineNames => record.medicines.map((e) => e.name).toList();

  List<Condition> _allConditions;
  List<String> get allConditionNames => _allConditions.map((e) => e.name).toList();
  List<String> get selectConditionNames => record.conditions.map((e) => e.name).toList();

  Future<void> _init() async {
    _record = await _repository.find(date);
    _allMedicines = await _medicineRepository.findAll();
    _allConditions = await _conditionRepository.findAll();
    loadSuccess();
  }

  void changeSelectedMedicine(List<String> selectedNamed) {
    AppLogger.d('選択しているお薬は ${selectedNamed.length} 個です');
    // TODO ここで入力情報として保持しておく
    // input
  }
}
