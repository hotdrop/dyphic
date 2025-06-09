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
    final conditions = await ref.read(conditionRepositoryProvider).findAll();
    ref.read(conditionUiStateProvider.notifier).state = _UiState(
      conditions: conditions,
      selectId: _UiState.emptyId,
      inputName: '',
    );
  }

  void selectCondition(Condition condition) {
    ref.read(conditionUiStateProvider.notifier).update((c) => c.copyWith(
          selectId: condition.id,
          inputName: condition.name,
        ));
    ref.read(conditionNameEditController).text = condition.name;
  }

  void inputName(String newVal) {
    ref.read(conditionUiStateProvider.notifier).update(
          (state) => state.copyWith(inputName: newVal),
        );
  }

  Future<void> save() async {
    try {
      final newCondition = ref.read(conditionUiStateProvider).createCondition();
      await ref.read(conditionRepositoryProvider).save(newCondition);
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void clear() {
    ref.read(conditionUiStateProvider.notifier).update((c) => c.copyWith(
          selectId: _UiState.emptyId,
          inputName: '',
        ));
    ref.read(conditionNameEditController).clear();
  }
}

// 現在、アプリにサインインしているか？
final isSignInProvider = Provider((ref) => ref.read(accountRepositoryProvider).isSignIn);

// 体調名のTextEditingController
final conditionNameEditController = Provider((_) => TextEditingController());

// 同名の症状がすでに登録されているか？enableSaveConditionProviderとほぼ同じだがエラーメッセージを表示したかったので別に作る
final conditionNameDuplicateProvider = Provider<bool>((ref) {
  final inputName = ref.watch(conditionUiStateProvider).inputName;
  final isExist = ref.watch(conditionUiStateProvider).isExist();
  return inputName.isNotEmpty && isExist;
});

// 入力した体調情報が保存可能か？
final enableSaveConditionProvider = Provider((ref) {
  final inputName = ref.watch(conditionUiStateProvider).inputName;
  final isDuplicate = ref.watch(conditionNameDuplicateProvider);
  return inputName.isNotEmpty && !isDuplicate;
});

final conditionUiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState({
    required this.conditions,
    required this.selectId,
    required this.inputName,
  });

  factory _UiState.empty() {
    return _UiState(conditions: [], selectId: emptyId, inputName: '');
  }

  List<Condition> conditions;
  int selectId;
  String inputName;

  static const emptyId = -1;

  String getSelectName() {
    final condition = conditions.firstWhereOrNull((c) => c.id == selectId);
    return condition?.name ?? '';
  }

  bool isSelected() {
    return selectId != emptyId;
  }

  bool isExist() {
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

  Condition createCondition() {
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
    String? inputName,
  }) {
    return _UiState(
      conditions: conditions ?? this.conditions,
      selectId: selectId ?? this.selectId,
      inputName: inputName ?? this.inputName,
    );
  }
}
