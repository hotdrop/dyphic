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

  Future<void> saveCondition(Record record) async {
    await saveItem(
      record.id,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionIdsStr: record.toConditionIdsStr(),
      conditionMemo: record.conditionMemo,
    );
  }

  Future<void> saveItem(
    int id, {
    String? breakfast,
    String? lunch,
    String? dinner,
    bool? isWalking,
    bool? isToilet,
    String? conditionIdsStr,
    String? conditionMemo,
    double? morningTemperature,
    double? nightTemperature,
    String? medicineIdsStr,
    String? memo,
    EventType? eventType,
    String? eventName,
  }) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    final target = box.get(id);
    if (target != null) {
      final entityUpdate = RecordEntity(
        id: id,
        breakfast: breakfast ?? target.breakfast,
        lunch: lunch ?? target.lunch,
        dinner: dinner ?? target.dinner,
        isWalking: isWalking ?? target.isWalking,
        isToilet: isToilet ?? target.isToilet,
        conditionIdsStr: conditionIdsStr ?? target.conditionIdsStr,
        conditionMemo: conditionMemo ?? target.conditionMemo,
        morningTemperature: morningTemperature ?? target.morningTemperature,
        nightTemperature: nightTemperature ?? target.nightTemperature,
        medicineIdsStr: medicineIdsStr ?? target.medicineIdsStr,
        memo: memo ?? target.memo,
        eventTypeIndex: eventType?.index ?? target.eventTypeIndex,
        eventName: eventName ?? target.eventName,
      );
      await box.put(id, entityUpdate);
    } else {
      final entityNew = RecordEntity(
        id: id,
        breakfast: breakfast,
        lunch: lunch,
        dinner: dinner,
        isWalking: isWalking ?? false,
        isToilet: isToilet ?? false,
        conditionIdsStr: conditionIdsStr,
        conditionMemo: conditionMemo,
        morningTemperature: morningTemperature,
        nightTemperature: nightTemperature,
        medicineIdsStr: medicineIdsStr,
        memo: memo,
        eventTypeIndex: eventType?.index ?? EventType.none.index,
        eventName: eventName,
      );
      await box.put(id, entityNew);
    }
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
      eventType: Record.toEventType(entity.eventTypeIndex),
      eventName: entity.eventName,
    );
  }

  RecordEntity _toEntity(Record record) {
    return RecordEntity(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionIdsStr: record.toConditionIdsStr(),
      conditionMemo: record.conditionMemo,
      morningTemperature: record.morningTemperature,
      nightTemperature: record.nightTemperature,
      medicineIdsStr: record.toMedicineIdsStr(),
      memo: record.memo,
      eventTypeIndex: record.eventType.index,
      eventName: record.eventName,
    );
  }
}
