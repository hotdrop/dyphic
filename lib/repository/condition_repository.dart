import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/remote/condition_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionRepositoryProvider = Provider((ref) => _ConditionRepository(ref.read));

class _ConditionRepository {
  const _ConditionRepository(this._read);

  final Reader _read;

  ///
  /// 体調情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Condition>> findAll(bool isForceUpdate) async {
    final conditions = await _read(conditionDaoProvider).findAll();
    if (conditions.isNotEmpty && !isForceUpdate) {
      return conditions;
    }

    // API経由でデータ取得
    final newConditions = await _read(conditionApiProvider).findAll();
    await _read(conditionDaoProvider).saveAll(newConditions);
    return newConditions;
  }

  Future<void> save(Condition condition) async {
    await _read(conditionApiProvider).save(condition);
    await _read(conditionDaoProvider).save(condition);
  }
}
