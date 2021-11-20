import 'package:dyphic/common/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/service/app_firebase.dart';

final conditionApiProvider = Provider((ref) => _ConditionApi(ref.read));

class _ConditionApi {
  const _ConditionApi(this._read);

  final Reader _read;

  Future<List<Condition>> findAll() async {
    AppLogger.d('サーバーから体調情報を全取得します。');
    return await _read(appFirebaseProvider).findConditions();
  }

  Future<void> save(Condition condition) async {
    AppLogger.d('サーバーに体調情報を保存します。');
    await _read(appFirebaseProvider).saveCondition(condition);
  }
}
