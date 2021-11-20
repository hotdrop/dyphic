import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/condition.dart';

final conditionViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _ConditionViewModel(ref.read));

class _ConditionViewModel extends BaseViewModel {
  _ConditionViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Condition? _selectedCondition;
  String get selectedConditionName => _selectedCondition?.name ?? '';
  bool get isSelected => _selectedCondition != null;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get editController => _controller;

  bool _enableOnSave = false;
  bool get enableOnSave => _enableOnSave;

  Future<void> _init() async {
    try {
      // 体調情報管理機能では必ず最新化してデータを取得する
      await _read(conditionsProvider.notifier).refresh();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('体調情報一覧の初回取得に失敗しました。', e, s);
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
    if (inputVal == null) {
      _enableOnSave = false;
      return null;
    }

    // 自分以外で入力値と重複する名前がある場合は重複エラー
    final isExist = _read(conditionsProvider.notifier).isExist(_selectedCondition?.id, inputVal);
    if (isExist) {
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
    try {
      await _read(conditionsProvider.notifier).save(_controller.text);
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void clear() {
    _selectedCondition = null;
    _enableOnSave = false;
    _controller.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
