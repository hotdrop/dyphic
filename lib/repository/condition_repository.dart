import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/remote/condition_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionRepositoryProvider = Provider((ref) => _ConditionRepository(ref));

class _ConditionRepository {
  const _ConditionRepository(this._ref);

  final Ref _ref;

  ///
  /// 保持している全ての体調情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<List<Condition>> findAll() async {
    final conditions = await _ref.read(conditionDaoProvider).findAll();
    if (conditions.isEmpty) {
      return [];
    }

    return conditions;
  }

  ///
  /// 体調情報がローカルストレージにロード済みであればtrue、ローカルのデータが0件であればfalse
  ///
  Future<bool> isLoaded() async {
    final conditions = await _ref.read(conditionDaoProvider).findAll();
    if (conditions.isEmpty) {
      return false;
    }
    return true;
  }

  ///
  /// 体調情報をサーバーから取得してローカルストレージのデータを最新化する
  /// 取得先: サーバー
  ///
  Future<void> onLoadLatest() async {
    final newConditions = await _ref.read(conditionApiProvider).findAll();
    await _ref.read(conditionDaoProvider).saveAll(newConditions);
  }

  ///
  /// 体調情報を保存する
  /// 保存先: ローカルストレージ, サーバー
  ///
  Future<void> save(Condition newCondition) async {
    await _ref.read(conditionApiProvider).save(newCondition);
    await _ref.read(conditionDaoProvider).save(newCondition);
  }
}
