import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/base_view_model.dart';

final recordViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _RecordViewModel(ref.read));

class _RecordViewModel extends BaseViewModel {
  _RecordViewModel(this._read);

  final Reader _read;

  late int _id;

  Set<int> _selectConditionIds = {};
  bool _inputIsWalking = false;
  bool _inputIsToilet = false;
  String _inputConditionMemo = '';
  Set<int> _selectMedicineIds = {};
  String _inputMemo = '';

  bool _isUpdate = false;

  Future<void> init(int id) async {
    _id = id;
    onSuccess();
  }

  Future<void> update() async {
    await _read(recordsProvider.notifier).update(_id);
  }

  bool isUpdate() {
    return _isUpdate;
  }

  Future<void> inputBreakfast(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordRepositoryProvider).saveBreakFast(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      onError('朝食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputLunch(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordRepositoryProvider).saveLunch(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      onError('昼食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputDinner(String? newVal) async {
    if (newVal == null) {
      return;
    }
    try {
      await _read(recordRepositoryProvider).saveDinner(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      onError('夕食の保存に失敗しました。 $e');
    }
  }

  Future<void> inputMorningTemperature(double newVal) async {
    try {
      await _read(recordRepositoryProvider).saveMorningTemperature(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
      onError('朝の体温の保存に失敗しました。 $e');
    }
  }

  Future<void> inputNightTemperature(double newVal) async {
    try {
      await _read(recordRepositoryProvider).saveNightTemperature(_id, newVal);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('夜の体温の保存に失敗しました。', e, s);
      onError('夜の体温の保存に失敗しました。 $e');
    }
  }

  // ここから体調情報

  void changeSelectedCondition(Set<int> selectedIds) {
    AppLogger.d('選択している症状は $selectedIds 個です');
    _selectConditionIds = selectedIds;
  }

  void inputIsWalking(bool? isWalking) {
    _inputIsWalking = isWalking ?? false;
  }

  void inputIsToilet(bool? isToilet) {
    _inputIsToilet = isToilet ?? false;
  }

  void inputConditionMemo(String newVal) {
    _inputConditionMemo = newVal;
  }

  Future<void> saveCondition() async {
    try {
      final newRecord = _createOnlyCondition(_id);
      await _read(recordRepositoryProvider).saveCondition(newRecord);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      onError('体調情報の保存に失敗しました。 $e');
    }
  }

  Record _createOnlyCondition(int id) {
    final conditions = _read(conditionsProvider).where((e) => _selectConditionIds.contains(e.id)).toList();
    return Record(
      id: id,
      isWalking: _inputIsWalking,
      isToilet: _inputIsToilet,
      conditions: conditions,
      conditionMemo: _inputConditionMemo,
      morningTemperature: null,
      nightTemperature: null,
      medicines: [],
      breakfast: null,
      lunch: null,
      dinner: null,
      memo: null,
    );
  }

  // ここからお薬情報

  void changeSelectedMedicine(Set<int> selectedIds) {
    AppLogger.d('選択しているお薬は $selectedIds です');
    _selectMedicineIds = selectedIds;
  }

  Future<void> saveMedicine() async {
    try {
      final idsStr = Record.setToMedicineIdsStr(_selectMedicineIds);
      await _read(recordRepositoryProvider).saveMedicineIds(_id, idsStr);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      onError('選択したお薬の保存に失敗しました。 $e');
    }
  }

  // ここからメモ情報
  void inputMemo(String newVal) {
    _inputMemo = newVal;
  }

  Future<void> saveMemo() async {
    try {
      await _read(recordRepositoryProvider).saveMemo(_id, _inputMemo);
      _isUpdate = true;
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      onError('メモの保存に失敗しました。 $e');
    }
  }
}
