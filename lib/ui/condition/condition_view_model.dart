import 'dart:math';
import 'package:flutter/material.dart';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/common/app_extension.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class ConditionViewModel extends NotifierViewModel {
  ConditionViewModel._(this._repository) {
    _init();
  }

  factory ConditionViewModel.create() {
    return ConditionViewModel._(ConditionRepository.create());
  }

  final ConditionRepository _repository;

  late List<Condition> _conditions;
  List<Condition> get conditions => _conditions;

  Condition _selectedCondition = Condition.empty();
  Condition get selectedCondition => _selectedCondition;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get editController => _controller;

  bool _enableOnSave = false;
  bool get enableOnSave => _enableOnSave;

  Future<void> _init() async {
    _conditions = await _repository.findAll();
    loadSuccess();
  }

  void selectCondition(Condition con) {
    _selectedCondition = con;
    _controller.text = con.name;
    _enableOnSave = true;
    notifyListeners();
  }

  String? inputValidator(String? inputVal) {
    if (inputVal.isNullOrEmpty()) {
      _enableOnSave = false;
      return null;
    }

    // 自分以外で入力値と重複する名前がある場合は重複エラー
    Condition sameNameCondition = conditions.firstWhere((c) => c.name == inputVal, orElse: () => Condition.empty());
    if (sameNameCondition.id != _selectedCondition.id) {
      _enableOnSave = false;
      return AppStrings.conditionInputDuplicateMessage;
    }

    _enableOnSave = true;
    return null;
  }

  void input(String name) {
    _controller.text = name;
    notifyListeners();
  }

  bool exist() {
    return _selectedCondition.exist;
  }

  Future<bool> onSave() async {
    AppLogger.d('${_controller.text} を保存します。');
    final newId = _createNewId();
    final c = _selectedCondition.copyWith(newId: newId, newName: _controller.text);
    try {
      await _repository.save(c);
      return true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      return false;
    }
  }

  int _createNewId() {
    if (conditions.isNotEmpty) {
      return conditions.map((e) => e.id).reduce(max) + 1;
    } else {
      return 1;
    }
  }

  Future<void> refresh() async {
    _conditions = await _repository.findAll();
    clear();
  }

  void clear() {
    _selectedCondition = Condition.empty();
    _enableOnSave = false;
    _controller.clear();
    notifyListeners();
  }
}
