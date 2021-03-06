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
    // TODO Firestoreから取得する
    // final conditions = [
    //   Condition(1, '頭痛'),
    //   Condition(2, '腹痛'),
    //   Condition(3, '倦怠感'),
    //   Condition(4, '便秘'),
    //   Condition(5, '筋肉痛'),
    // ];

    final conditions = await _appFirebase.readConditions();
    AppLogger.d('お薬情報を全て取得しました。データ数: ${conditions.length}');

    return conditions;
  }

  Future<void> save(Condition condition) async {
    await _appFirebase.writeCondition(condition);
    AppLogger.d('体調情報を保存します。\n${condition.toString()}');
  }
}
