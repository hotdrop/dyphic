import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/entity/medicine_entity.dart';
import 'package:isar/isar.dart';

final medicineDaoProvider = Provider((ref) => _MedicineDao(ref));

class _MedicineDao {
  const _MedicineDao(this._ref);

  final Ref _ref;

  Future<Medicine?> find(int id) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final medicine = await isar.medicineEntitys.get(id);
    if (medicine == null) {
      return null;
    }
    return _toMedicine(medicine);
  }

  Future<List<Medicine>> findAll() async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final medicines = await isar.medicineEntitys.where().findAll();
    return medicines.map((m) => _toMedicine(m)).toList();
  }

  Future<void> save(Medicine medicine) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _toEntity(medicine);
      await isar.medicineEntitys.put(entity);
    });
  }

  Future<void> saveAll(List<Medicine> medicines) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = medicines.map((r) => _toEntity(r)).toList();
      await isar.medicineEntitys.clear();
      await isar.medicineEntitys.putAll(entities);
    });
  }

  Future<void> updateDefaultState(int medicineId, bool isDefault) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = await isar.medicineEntitys.get(medicineId);
      if (entity != null) {
        final updatedEntity = MedicineEntity(
          id: entity.id,
          name: entity.name,
          overview: entity.overview,
          typeIndex: entity.typeIndex,
          memo: entity.memo,
          order: entity.order,
          isDefault: isDefault,
        );
        await isar.medicineEntitys.put(updatedEntity);
      }
    });
  }

  Medicine _toMedicine(MedicineEntity entity) {
    return Medicine(
      id: entity.id,
      name: entity.name,
      overview: entity.overview,
      type: Medicine.toType(entity.typeIndex),
      memo: entity.memo,
      order: entity.order,
      isDefault: entity.isDefault,
    );
  }

  MedicineEntity _toEntity(Medicine m) {
    return MedicineEntity(
      id: m.id,
      name: m.name,
      overview: m.overview,
      typeIndex: m.type.index,
      memo: m.memo,
      order: m.order,
      isDefault: m.isDefault,
    );
  }
}
