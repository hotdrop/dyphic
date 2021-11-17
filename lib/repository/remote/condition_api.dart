import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/service/app_firebase.dart';

final conditionApiProvider = Provider((ref) => _ConditionApi(ref.read));

class _ConditionApi {
  const _ConditionApi(this._read);

  final Reader _read;

  Future<List<Condition>> findAll() async {
    return await _read(appFirebaseProvider).findConditions();
  }

  Future<void> save(Condition condition) async {
    await _read(appFirebaseProvider).saveCondition(condition);
  }
}
