import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/local/dao/condition_dao.dart';
import 'package:dyphic/repository/remote/condition_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionRepositoryProvider = Provider((ref) => _ConditionRepository(ref));

class _ConditionRepository {
  const _ConditionRepository(this._ref);

  final Ref _ref;

  ///
  /// 全ての体調情報を取得する
  /// isLoadLatest がtrueの場合は強制でサーバーからデータを取得する
  /// 取得先:
  ///   ローカルストレージ: 体調情報がロード済みの場合
  ///   サーバー: 体調情報がローカルストレージに存在しない場合
  ///
  Future<List<Condition>> findAll({bool isLoadLatest = false}) async {
    if (isLoadLatest) {
      final newConditions = await _ref.read(conditionApiProvider).findAll();
      await _ref.read(conditionDaoProvider).saveAll(newConditions);
      return newConditions;
    }

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
  /// 体調情報を最新データに更新する
  /// 取得先: サーバー
  ///
  Future<void> onLoadLatest() async {
    final newConditions = await _ref.read(conditionDaoProvider).findAll();
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
