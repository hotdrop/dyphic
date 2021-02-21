import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/remote/condition_api.dart';

class ConditionRepository {
  const ConditionRepository._(this._conditionApi);

  factory ConditionRepository.create({ConditionApi argApi}) {
    final api = argApi ?? ConditionApi.create();
    return ConditionRepository._(api);
  }

  final ConditionApi _conditionApi;

  Future<List<Condition>> findAll() async {
    final conditions = await _conditionApi.findAll();
    AppLogger.i('ConditionApiでお薬情報を取得しました。データ数: ${conditions.length}');
    return conditions;
  }

  Future<void> save(Condition condition) async {
    return await _conditionApi.save(condition);
  }
}
