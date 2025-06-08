import 'dart:math';

import 'package:dyphic/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/common/app_extension.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';

part 'condition_controller.g.dart';

@riverpod
class ConditionController extends _$ConditionController {
  @override
  Future<void> build() async {
    ref.onDispose(() {
      ref.read(conditionNameEditController).dispose();
    });

    final conditions = await ref.read(conditionRepositoryProvider).findAll();
    ref.read(conditionUiStateProvider.notifier).state = _UiState(
      conditions: conditions,
      selectId: _UiState.emptyId,
    );
  }

  void selectCondition(Condition condition) {
    ref.read(conditionUiStateProvider.notifier).update((c) => c.copyWith(
          selectId: condition.id,
        ));
    ref.read(conditionNameEditController).text = condition.name;
  }

  // TODO これ不要では？
  // void input(String name) {
  //   ref.read(conditionNameEditController).text = name;
  // }

  Future<void> save() async {
    try {
      final inputName = ref.read(conditionNameEditController).text;
      final newCondition = ref.read(conditionUiStateProvider).createCondition(inputName);
      await ref.read(conditionRepositoryProvider).save(newCondition);
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void clear() {
    ref.read(conditionUiStateProvider.notifier).update((c) => c.copyWith(
          selectId: _UiState.emptyId,
        ));
    ref.read(conditionNameEditController).clear();
  }
}

// 現在、アプリにサインインしているか？
final isSignInProvider = Provider((ref) => ref.read(accountRepositoryProvider).isSignIn);

// 体調名のTextEditingController
final conditionNameEditController = Provider((_) => TextEditingController());

// 入力した体調情報が保存可能か？
final enableSaveConditionProvider = Provider((ref) {
  final inputText = ref.watch(conditionNameEditController).text;
  if (inputText.isEmpty) {
    return false;
  }
  final isExist = ref.read(conditionUiStateProvider).isExist(inputText);
  return !isExist;
});

final conditionUiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState({
    required this.conditions,
    required this.selectId,
  });

  factory _UiState.empty() {
    return _UiState(conditions: [], selectId: emptyId);
  }

  List<Condition> conditions;
  int selectId;

  static const emptyId = -1;

  String getSelectName() {
    final condition = conditions.firstWhereOrNull((c) => c.id == selectId);
    return condition?.name ?? '';
  }

  bool isSelected() {
    return selectId != emptyId;
  }

  bool isExist(String inputName) {
    final condition = conditions.firstWhereOrNull((c) => c.name == inputName);
    if (condition == null) {
      return false;
    }
    // 同名が存在する場合、idが初期状態であれば「存在する」と判定する
    if (selectId == emptyId) {
      return true;
    }

    return selectId != condition.id;
  }

  Condition createCondition(String inputName) {
    if (selectId == emptyId) {
      return Condition(_createNewId(), inputName);
    } else {
      return Condition(selectId, inputName);
    }
  }

  int _createNewId() {
    return (conditions.isNotEmpty) ? conditions.map((e) => e.id).reduce(max) + 1 : 1;
  }

  _UiState copyWith({
    List<Condition>? conditions,
    int? selectId,
  }) {
    return _UiState(
      conditions: conditions ?? this.conditions,
      selectId: selectId ?? this.selectId,
    );
  }
}
