import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/service/firestore.dart';

final medicineApiProvider = Provider((ref) => _MedicineApi(ref));

class _MedicineApi {
  const _MedicineApi(this._ref);

  final Ref _ref;

  Future<List<Medicine>> findAll() async {
    AppLogger.d('サーバーからお薬を全取得します。');
    return await _ref.read(firestoreProvider).findMedicines();
  }

  Future<void> save(Medicine medicine) async {
    AppLogger.d('サーバーにお薬を保存します。');
    await _ref.read(firestoreProvider).saveMedicine(medicine);
  }
}
