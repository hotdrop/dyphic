import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/dao/medicine_dao.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';

final medicineRepositoryProvider = Provider((ref) => _MedicineRepository(ref));

class _MedicineRepository {
  const _MedicineRepository(this._ref);

  final Ref _ref;

  ///
  /// お薬情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Medicine>> findAll({required bool isForceUpdate}) async {
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    if (medicines.isNotEmpty && !isForceUpdate) {
      medicines.sort((a, b) => a.order - b.order);
      return medicines;
    }

    final newMedicines = await _ref.read(medicineApiProvider).findAll();
    newMedicines.sort((a, b) => a.order - b.order);
    await _ref.read(medicineDaoProvider).saveAll(newMedicines);
    return newMedicines;
  }

  Future<void> save(Medicine newMedicine) async {
    await _ref.read(medicineApiProvider).save(newMedicine);
    await _ref.read(medicineDaoProvider).save(newMedicine);
  }
}
