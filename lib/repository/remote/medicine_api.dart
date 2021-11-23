import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineApiProvider = Provider((ref) => _MedicineApi(ref.read));

class _MedicineApi {
  const _MedicineApi(this._read);

  final Reader _read;

  Future<List<Medicine>> findAll() async {
    AppLogger.d('サーバーからお薬を全取得します。');
    return await _read(appFirebaseProvider).findMedicines();
  }

  Future<void> save(Medicine medicine) async {
    AppLogger.d('サーバーにお薬を保存します。');
    await _read(appFirebaseProvider).saveMedicine(medicine);
  }

  Future<String> updateImage(String imagePath) async {
    AppLogger.d('サーバーにお薬の画像情報を保存します。');
    return await _read(appFirebaseProvider).saveImage(imagePath);
  }
}
