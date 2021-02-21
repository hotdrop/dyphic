import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(this.date, this._repository, this._medicineRepository);

  factory RecordViewModel.create(DateTime date, {RecordRepository argRecordRepo, MedicineRepository argMedicineRepo}) {
    final recordRepo = argRecordRepo ?? RecordRepository.create();
    final medicineRepo = argMedicineRepo ?? MedicineRepository.create();
    return RecordViewModel._(date, recordRepo, medicineRepo);
  }

  final DateTime date;
  final RecordRepository _repository;
  final MedicineRepository _medicineRepository;

  Record _record;
  Record get record => _record;
  List<Medicine> _allMedicines;
  List<Medicine> get allMedicines => _allMedicines;
  List<String> get takenMedicineNames => record.medicines.map((e) => e.name).toList();

  Future<void> init() async {
    _record = await _repository.find(date);
    _allMedicines = await _medicineRepository.findAll();
    loadSuccess();
  }

  void changeSelectedMedicine(List<String> selectedNamed) {
    AppLogger.d('選択しているお薬は ${selectedNamed.length} 個です');
    // TODO ここで入力情報として保持しておく
  }
}
