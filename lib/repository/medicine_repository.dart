import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/medicine.dart';
import 'package:dalico/repository/local/medicine_database.dart';
import 'package:dalico/repository/remote/medicine_api.dart';

class MedicineRepository {
  const MedicineRepository._(this._medicineApi, this._medicineDb);

  factory MedicineRepository.create() {
    return MedicineRepository._(MedicineApi.create(), MedicineDatabase.create());
  }

  final MedicineApi _medicineApi;
  final MedicineDatabase _medicineDb;

  Future<List<Medicine>> findAll(AppSettings appSettings) async {
    final latestMedicines = await _medicineApi.findByLatest(appSettings);
    if (latestMedicines.isNotEmpty) {
      await _medicineDb.update(latestMedicines);
    }
    return await _medicineDb.findAll();
  }
}
