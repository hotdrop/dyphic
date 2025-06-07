import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/remote/condition_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionRepositoryProvider = Provider((ref) => _ConditionRepository(ref));

class _ConditionRepository {
  const _ConditionRepository(this._ref);

  final Ref _ref;

  ///
  /// 体調情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Condition>> findAll({required bool isForceUpdate}) async {
    final conditions = await _ref.read(conditionDaoProvider).findAll();
    if (conditions.isNotEmpty && !isForceUpdate) {
      return conditions;
    }

    final newConditions = await _ref.read(conditionApiProvider).findAll();
    await _ref.read(conditionDaoProvider).saveAll(newConditions);
    return newConditions;
  }

  Future<void> save(Condition newCondition) async {
    await _ref.read(conditionApiProvider).save(newCondition);
    await _ref.read(conditionDaoProvider).save(newCondition);
  }
}
