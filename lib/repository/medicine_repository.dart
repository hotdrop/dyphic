import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';

class MedicineRepository {
  const MedicineRepository._(this._medicineApi);

  factory MedicineRepository.create() {
    return MedicineRepository._(MedicineApi.create());
  }

  final MedicineApi _medicineApi;

  Future<List<Medicine>> findAll() async {
    return await _medicineApi.findAll();
  }

  Future<void> save(Medicine medicine) async {
    return await _medicineApi.save(medicine);
  }
}
