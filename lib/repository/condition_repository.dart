import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/remote/condition_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionRepositoryProvider = Provider((ref) => _ConditionRepository(ref.read));

class _ConditionRepository {
  const _ConditionRepository(this._read);

  final Reader _read;

  Future<List<Condition>> findAll() async {
    return await _read(conditionApiProvider).findAll();
  }

  Future<void> save(Condition condition) async {
    return await _read(conditionApiProvider).save(condition);
  }
}
