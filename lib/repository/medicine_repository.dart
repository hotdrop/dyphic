import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineRepositoryProvider = Provider((ref) => _MedicineRepository(ref.read));

class _MedicineRepository {
  const _MedicineRepository(this._read);

  final Reader _read;

  Future<List<Medicine>> findAll() async {
    final medicines = await _read(medicineApiProvider).findAll();
    medicines.sort((a, b) => a.order - b.order);
    AppLogger.d('お薬情報を取得しました。データ数: ${medicines.length}');
    return medicines;
  }

  Future<void> save(Medicine medicine, bool isUpdateImage) async {
    Medicine newMedicine = medicine;
    if (medicine.imagePath.isNotEmpty && isUpdateImage) {
      final saveUrl = await _read(medicineApiProvider).updateImage(medicine.imagePath);
      newMedicine = medicine.copyWith(imageUrl: saveUrl);
    }

    AppLogger.d('お薬情報を保存します。\n${newMedicine.toString()}');
    await _read(medicineApiProvider).save(newMedicine);
  }
}
