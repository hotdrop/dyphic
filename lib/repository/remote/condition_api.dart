import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';

class ConditionApi {
  const ConditionApi._();

  factory ConditionApi.create() {
    return ConditionApi._();
  }

  Future<List<Condition>> findAll() async {
    // TODO Firestoreから取得する
    return [
      Condition(1, '頭痛'),
      Condition(2, '腹痛'),
      Condition(3, '倦怠感'),
      Condition(4, '便秘'),
      Condition(5, '筋肉痛'),
    ];
  }

  Future<void> save(Condition condition) async {
    // TODO 登録/更新する
    if (condition.exist) {
      AppLogger.d('${condition.name} を更新します。');
    } else {
      AppLogger.d('${condition.name} を登録します。');
    }
  }
}
