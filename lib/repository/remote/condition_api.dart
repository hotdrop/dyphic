import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/service/app_firebase.dart';

class ConditionApi {
  const ConditionApi._(this._appFirebase);

  factory ConditionApi.create() {
    return ConditionApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<Condition>> findAll() async {
    final conditions = await _appFirebase.findConditions();
    AppLogger.d('お薬情報を全て取得しました。データ数: ${conditions.length}');

    return conditions;
  }

  Future<void> save(Condition condition) async {
    await _appFirebase.saveCondition(condition);
    AppLogger.d('体調情報を保存します。\n${condition.toString()}');
  }
}
