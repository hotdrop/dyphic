import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';
import 'package:flutter/material.dart';

class ConditionViewModel extends NotifierViewModel {
  ConditionViewModel._(this._repository) {
    _init();
  }

  factory ConditionViewModel.create({ConditionRepository argRepo}) {
    final repo = argRepo ?? ConditionRepository.create();
    return ConditionViewModel._(repo);
  }

  final ConditionRepository _repository;
  List<Condition> conditions;

  Condition _selectedCondition = Condition.empty();
  Condition get selectedCondition => _selectedCondition;

  TextEditingController _controller = TextEditingController();
  TextEditingController get editController => _controller;
  bool get enableOnSave => _controller.text.isNotEmpty;

  Future<void> _init() async {
    conditions = await _repository.findAll();
    loadSuccess();
  }

  void selectCondition(Condition con) {
    _selectedCondition = con;
    _controller.text = con.name;
    notifyListeners();
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
    final c = _selectedCondition.copyWith(newName: _controller.text);
    try {
      await _repository.save(c);
      return true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      return false;
    }
  }

  Future<void> refresh() async {
    conditions = await _repository.findAll();
    clear();
  }

  void clear() {
    _selectedCondition = Condition.empty();
    _controller.clear();
    notifyListeners();
  }
}
