import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/dao/medicine_dao.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';

final medicineRepositoryProvider = Provider((ref) => _MedicineRepository(ref.read));

class _MedicineRepository {
  const _MedicineRepository(this._read);

  final Reader _read;

  ///
  /// お薬情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Medicine>> findAll({required bool isForceUpdate}) async {
    final medicines = await _read(medicineDaoProvider).findAll();
    if (medicines.isNotEmpty && !isForceUpdate) {
      medicines.sort((a, b) => a.order - b.order);
      return medicines;
    }

    // API経由でデータ取得
    final newMedicines = await _read(medicineApiProvider).findAll();
    newMedicines.sort((a, b) => a.order - b.order);
    await _read(medicineDaoProvider).saveAll(newMedicines);
    return newMedicines;
  }

  Future<void> save(Medicine medicine, bool isUpdateImage) async {
    Medicine newMedicine = medicine;
    if (medicine.imagePath.isNotEmpty && isUpdateImage) {
      final saveUrl = await _read(medicineApiProvider).updateImage(medicine.imagePath);
      newMedicine = medicine.copyWith(imageUrl: saveUrl);
    }

    await _read(medicineApiProvider).save(newMedicine);
    await _read(medicineDaoProvider).save(newMedicine);
  }
}
