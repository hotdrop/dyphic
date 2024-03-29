import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:collection/collection.dart';

final conditionsProvider = StateNotifierProvider<_ConditionNotifier, List<Condition>>((ref) => _ConditionNotifier(ref.read));

class _ConditionNotifier extends StateNotifier<List<Condition>> {
  _ConditionNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> onLoad() async {
    state = await _read(conditionRepositoryProvider).findAll(isForceUpdate: false);
  }

  Future<void> refresh() async {
    state = await _read(conditionRepositoryProvider).findAll(isForceUpdate: true);
  }

  bool isExist(int? id, String name) {
    final condition = state.firstWhereOrNull((c) => c.name == name);
    if (condition == null) {
      return false;
    }
    // 同名が存在する場合、idがnullであれば「存在する」と判定する
    if (id == null) {
      return true;
    }

    return id != condition.id;
  }

  Condition newCondition(String name) {
    final newId = _createNewId();
    return Condition(newId, name);
  }

  Future<void> save(Condition condition) async {
    await _read(conditionRepositoryProvider).save(condition);
    await onLoad();
  }

  int _createNewId() {
    return (state.isNotEmpty) ? state.map((e) => e.id).reduce(max) + 1 : 1;
  }
}

class Condition {
  const Condition(this.id, this.name);

  final int id;
  final String name;

  Condition copyWith({int? newId, String? newName}) {
    return Condition(
      newId ?? id,
      newName ?? name,
    );
  }

  @override
  String toString() {
    return ' id: $id \n name: $name';
  }
}
