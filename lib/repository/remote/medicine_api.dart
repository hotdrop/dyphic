import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/service/app_firebase.dart';

class MedicineApi {
  const MedicineApi._(this._appFirebase);

  factory MedicineApi.create() {
    return MedicineApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<Medicine>> findAll() async {
    final medicines = await _appFirebase.findMedicines();
    medicines.sort((a, b) => a.order - b.order);
    AppLogger.d('お薬情報を取得しました。データ数: ${medicines.length}');
    return medicines;
  }

  Future<void> save(Medicine medicine) async {
    Medicine newMedicine = medicine;
    if (medicine.imagePath.isNotEmpty) {
      final saveUrl = await _appFirebase.saveImage(medicine.imagePath);
      newMedicine = medicine.copy(imageUrl: saveUrl);
    }

    AppLogger.d('お薬情報を保存します。\n${newMedicine.toString()}');
    await _appFirebase.saveMedicine(newMedicine);
  }
}
