import 'package:dalico/common/app_logger.dart';
import 'package:dalico/model/medicine.dart';
import 'package:dalico/repository/remote/medicine_api.dart';

class MedicineRepository {
  const MedicineRepository._(this._medicineApi);

  factory MedicineRepository.create() {
    return MedicineRepository._(MedicineApi.create());
  }

  final MedicineApi _medicineApi;

  Future<List<Medicine>> findAll() async {
    final medicines = await _medicineApi.findAll();
    AppLogger.i('MedicineApiでお薬情報を取得しました。データ数: ${medicines.length}');
    return medicines;
  }
}
