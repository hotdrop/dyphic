import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/service/firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/condition.dart';

final conditionApiProvider = Provider((ref) => _ConditionApi(ref));

class _ConditionApi {
  const _ConditionApi(this._ref);

  final Ref _ref;

  Future<List<Condition>> findAll() async {
    AppLogger.d('サーバーから体調情報を全取得します。');
    return await _ref.read(firestoreProvider).findConditions();
  }

  Future<void> save(Condition condition) async {
    AppLogger.d('サーバーに体調情報を保存します。');
    await _ref.read(firestoreProvider).saveCondition(condition);
  }
}
