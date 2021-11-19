import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/entity/condition_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final conditionDaoProvider = Provider((ref) => const _ConditionDao());

class _ConditionDao {
  const _ConditionDao();

  Future<List<Condition>> findAll() async {
    final box = await Hive.openBox<ConditionEntity>(ConditionEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    return box.values.map((c) => _toCondition(c)).toList();
  }

  Future<void> saveAll(List<Condition> conditions) async {
    final box = await Hive.openBox<ConditionEntity>(ConditionEntity.boxName);
    final entities = conditions.map((c) => _toEntity(c)).toList();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  Future<void> save(Condition condition) async {
    final box = await Hive.openBox<ConditionEntity>(ConditionEntity.boxName);
    final entity = _toEntity(condition);
    await box.put(entity.id, entity);
  }

  Condition _toCondition(ConditionEntity entity) {
    return Condition(entity.id, entity.name);
  }

  ConditionEntity _toEntity(Condition c) {
    return ConditionEntity(id: c.id, name: c.name);
  }
}
