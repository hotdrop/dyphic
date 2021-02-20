import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';

class MedicineRepository {
  const MedicineRepository._(this._medicineApi);

  factory MedicineRepository.create({MedicineApi argApi}) {
    final api = argApi ?? MedicineApi.create();
    return MedicineRepository._(api);
  }

  final MedicineApi _medicineApi;

  Future<List<Medicine>> findAll() async {
    final medicines = await _medicineApi.findAll();
    AppLogger.i('MedicineApiでお薬情報を取得しました。データ数: ${medicines.length}');
    return medicines;
  }

  Future<void> save(Medicine medicine) async {
    return await _medicineApi.save(medicine);
  }
}
