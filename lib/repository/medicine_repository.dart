import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/dao/medicine_dao.dart';
import 'package:dyphic/repository/remote/medicine_api.dart';

final medicineRepositoryProvider = Provider((ref) => _MedicineRepository(ref));

class _MedicineRepository {
  const _MedicineRepository(this._ref);

  final Ref _ref;

  ///
  /// 指定したIDのお薬情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<Medicine?> find(int id) async {
    return await _ref.read(medicineDaoProvider).find(id);
  }

  ///
  /// 保持している全お薬情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<List<Medicine>> findAll() async {
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    if (medicines.isEmpty) {
      return [];
    }

    medicines.sort((a, b) => a.order - b.order);
    return medicines;
  }

  ///
  /// お薬情報がローカルストレージにロード済みであればtrue、ローカルのデータが0件であればfalse
  ///
  Future<bool> isLoaded() async {
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    if (medicines.isEmpty) {
      return false;
    }
    return true;
  }

  ///
  /// お薬情報をサーバーから取得してローカルストレージのデータを最新化する
  /// 取得先: サーバー
  ///
  Future<void> onLoadLatest() async {
    final newMedicines = await _ref.read(medicineApiProvider).findAll();
    await _ref.read(medicineDaoProvider).saveAll(newMedicines);
  }

  ///
  /// お薬情報を保存する
  /// 保存先: ローカルストレージ, サーバー
  ///
  Future<void> save(Medicine newMedicine) async {
    await _ref.read(medicineApiProvider).save(newMedicine);
    await _ref.read(medicineDaoProvider).save(newMedicine);
  }

  ///
  /// お薬のデフォルト表示状態を更新する
  /// 更新先: ローカルストレージ
  ///
  Future<void> updateDefaultState(int medicineId, bool isDefault) async {
    await _ref.read(medicineDaoProvider).updateDefaultState(medicineId, isDefault);
  }
}
