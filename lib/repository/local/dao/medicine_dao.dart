import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/local/entity/medicine_entity.dart';

final medicineDaoProvider = Provider((ref) => const _MedicineDao());

class _MedicineDao {
  const _MedicineDao();

  Future<List<Medicine>> findAll() async {
    final box = await Hive.openBox<MedicineEntity>(MedicineEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    return box.values.map((m) => _toMedicine(m)).toList();
  }

  Future<void> saveAll(List<Medicine> medicines) async {
    final box = await Hive.openBox<MedicineEntity>(MedicineEntity.boxName);
    final entities = medicines.map((c) => _toEntity(c)).toList();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  Future<void> save(Medicine medicine) async {
    final box = await Hive.openBox<MedicineEntity>(MedicineEntity.boxName);
    final entity = _toEntity(medicine);
    await box.put(entity.id, entity);
  }

  Medicine _toMedicine(MedicineEntity entity) {
    return Medicine(
      id: entity.id,
      name: entity.name,
      overview: entity.overview,
      type: Medicine.toType(entity.typeIndex),
      memo: entity.memo,
      imagePath: entity.imagePath,
      order: entity.order,
    );
  }

  MedicineEntity _toEntity(Medicine m) {
    return MedicineEntity(
      id: m.id,
      name: m.name,
      overview: m.overview,
      typeIndex: m.type.index,
      memo: m.memo,
      imagePath: m.imagePath,
      order: m.order,
    );
  }
}
