import 'dart:math';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/common/app_extension.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conditionViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _ConditionViewModel(ref.read));

class _ConditionViewModel extends BaseViewModel {
  _ConditionViewModel(this._read) {
    _init();
  }

  final Reader _read;

  bool get isSignIn => _read(accountRepositoryProvider).isSignIn;

  late List<Condition> _conditions;
  List<Condition> get conditions => _conditions;

  Condition _selectedCondition = Condition.empty();
  Condition get selectedCondition => _selectedCondition;
  String get selectedConditionName => _selectedCondition.name;
  bool get exist => _selectedCondition.exist;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get editController => _controller;

  bool _enableOnSave = false;
  bool get enableOnSave => _enableOnSave;

  Future<void> _init() async {
    try {
      _conditions = await _read(conditionRepositoryProvider).findAll();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('体調情報一覧の初回取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> refresh() async {
    try {
      _conditions = await _read(conditionRepositoryProvider).findAll();
      clear();
    } catch (e, s) {
      await AppLogger.e('体調情報一覧の取得に失敗しました。', e, s);
      onError('$e');
    }
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

  Future<void> save() async {
    AppLogger.d('${_controller.text} を保存します。');
    final newId = _createNewId();
    final c = _selectedCondition.copyWith(newId: newId, newName: _controller.text);
    try {
      await _read(conditionRepositoryProvider).save(c);
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  int _createNewId() {
    return (conditions.isNotEmpty) ? conditions.map((e) => e.id).reduce(max) + 1 : 1;
  }

  void clear() {
    _selectedCondition = Condition.empty();
    _enableOnSave = false;
    _controller.clear();
    notifyListeners();
  }
}
