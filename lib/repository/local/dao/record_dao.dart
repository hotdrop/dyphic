import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/local/entity/record_entity.dart';

final recordDaoProvider = Provider((ref) => _RecordDao(ref.read));

class _RecordDao {
  const _RecordDao(this._read);

  final Reader _read;

  Future<List<Record>> findAll() async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    return box.values.map((e) => _toRecord(e)).toList();
  }

  Future<Record?> find(int id) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    final entity = box.values.firstWhereOrNull((e) => e.id == id);
    if (entity == null) {
      return null;
    }
    return _toRecord(entity);
  }

  Future<void> saveAll(List<Record> records) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    final entities = records.map((r) => _toEntity(r)).toList();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  Future<void> save(Record record) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    final entity = _toEntity(record);
    await box.put(entity.id, entity);
  }

  Record _toRecord(RecordEntity entity) {
    final conditions = _read(conditionsProvider);
    final medicines = _read(medicineProvider);

    return Record(
      id: entity.id,
      isWalking: entity.isWalking,
      isToilet: entity.isToilet,
      conditions: Record.toConditions(conditions, entity.conditionIdsStr),
      conditionMemo: entity.conditionMemo,
      morningTemperature: entity.morningTemperature,
      nightTemperature: entity.nightTemperature,
      medicines: Record.toMedicines(medicines, entity.medicineIdsStr),
      breakfast: entity.breakfast,
      lunch: entity.lunch,
      dinner: entity.dinner,
      memo: entity.memo,
    );
  }

  RecordEntity _toEntity(Record record) {
    final conditions = _read(conditionsProvider);
    final medicines = _read(medicineProvider);

    return RecordEntity(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionIdsStr: record.toConditionIdsStr(conditions),
      conditionMemo: record.conditionMemo,
      morningTemperature: record.morningTemperature,
      nightTemperature: record.nightTemperature,
      medicineIdsStr: record.toMedicineIdsStr(medicines),
      memo: record.memo,
    );
  }
}
