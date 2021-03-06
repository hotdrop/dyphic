import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/remote/condition_api.dart';

class ConditionRepository {
  const ConditionRepository._(this._conditionApi);

  factory ConditionRepository.create() {
    return ConditionRepository._(ConditionApi.create());
  }

  final ConditionApi _conditionApi;

  Future<List<Condition>> findAll() async {
    return await _conditionApi.findAll();
  }

  Future<void> save(Condition condition) async {
    return await _conditionApi.save(condition);
  }
}
