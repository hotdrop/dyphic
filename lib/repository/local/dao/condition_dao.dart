import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/entity/condition_entity.dart';
import 'package:dyphic/repository/local/local_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final conditionDaoProvider = Provider((ref) => _ConditionDao(ref));

class _ConditionDao {
  const _ConditionDao(this._ref);

  final Ref _ref;

  Future<List<Condition>> findAll() async {
    final isar = _ref.read(localDataSourceProvider).isar;
    final conditions = await isar.conditionEntitys.where().findAll();
    return conditions.map((c) => _toCondition(c)).toList();
  }

  Future<void> save(Condition condition) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _toEntity(condition);
      await isar.conditionEntitys.put(entity);
    });
  }

  Future<void> saveAll(List<Condition> conditions) async {
    final isar = _ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = conditions.map((c) => _toEntity(c)).toList();
      await isar.clear();
      await isar.conditionEntitys.putAll(entities);
    });
  }

  Condition _toCondition(ConditionEntity entity) {
    return Condition(entity.id, entity.name);
  }

  ConditionEntity _toEntity(Condition c) {
    return ConditionEntity(id: c.id, name: c.name);
  }
}
