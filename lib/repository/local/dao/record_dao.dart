import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/local/dao/medicine_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/local/entity/record_entity.dart';

final recordDaoProvider = Provider((ref) => _RecordDao(ref));

class _RecordDao {
  const _RecordDao(this._ref);

  final Ref _ref;

  Future<Record> find(int id) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final record = await isar.recordEntitys.get(id);
    if (record == null) {
      throw Exception('Record not found');
    }
    final conditions = await _ref.read(conditionDaoProvider).findAll();
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    return _toRecord(record, conditions, medicines);
  }

  Future<List<Record>> findAll() async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final records = await isar.recordEntitys.where().findAll();
    final conditions = await _ref.read(conditionDaoProvider).findAll();
    final medicines = await _ref.read(medicineDaoProvider).findAll();
    return records.map((e) => _toRecord(e, conditions, medicines)).toList();
  }

  Future<void> save(Record record) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _toEntity(record);
      await isar.recordEntitys.put(entity);
    });
  }

  Future<void> saveAll(List<Record> records) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = records.map((r) => _toEntity(r)).toList();
      await isar.clear();
      await isar.recordEntitys.putAll(entities);
    });
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
    final isar = _ref.read(localDataSourceProvider).isar;
    final target = await isar.recordEntitys.get(id);
    if (target != null) {
      final newVal = RecordEntity(
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
      await isar.writeTxn(() async {
        await isar.recordEntitys.put(newVal);
      });
    } else {
      final newVal = RecordEntity(
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
      await isar.writeTxn(() async {
        await isar.recordEntitys.put(newVal);
      });
    }
  }

  Record _toRecord(RecordEntity entity, List<Condition> conditions, List<Medicine> medicines) {
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
