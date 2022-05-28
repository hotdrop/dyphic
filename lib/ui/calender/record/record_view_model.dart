import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/calender/calendar_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/record.dart';

final recordViewModel = Provider<_RecordViewModel>((ref) => throw UnimplementedError());

final recordViewModelFamily = Provider.family<_RecordViewModel, int>((ref, recordId) {
  return _RecordViewModel(ref.read, recordId);
});

class _RecordViewModel {
  _RecordViewModel(this._read, this.recordId);

  final Reader _read;
  final int recordId;

  void init(Record record) {
    _read(_uiStateProvider.notifier).init(record);
  }

  Future<void> inputBreakfast(String newVal) async {
    try {
      await _read(recordRepositoryProvider).saveBreakFast(recordId, newVal);
      _read(_uiStateProvider.notifier).inputBreakfast(newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputLunch(String newVal) async {
    try {
      await _read(recordRepositoryProvider).saveLunch(recordId, newVal);
      _read(_uiStateProvider.notifier).inputLunch(newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputDinner(String newVal) async {
    try {
      await _read(recordRepositoryProvider).saveDinner(recordId, newVal);
      _read(_uiStateProvider.notifier).inputDinner(newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputMorningTemperature(double newVal) async {
    try {
      await _read(recordRepositoryProvider).saveMorningTemperature(recordId, newVal);
      _read(_uiStateProvider.notifier).inputMorningTemperature(newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputNightTemperature(double newVal) async {
    try {
      await _read(recordRepositoryProvider).saveNightTemperature(recordId, newVal);
      _read(_uiStateProvider.notifier).inputNightTemperature(newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('夜の体温の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void selectConditionIds(Set<int> newVal) {
    _read(_uiStateProvider.notifier).selectConditionIds(newVal);
  }

  void inputIsWalking(bool newVal) {
    _read(_uiStateProvider.notifier).inputWalking(newVal);
  }

  void inputIsToilet(bool newVal) {
    _read(_uiStateProvider.notifier).inputToilet(newVal);
  }

  void inputConditionMemo(String newVal) {
    _read(_uiStateProvider.notifier).inputMemo(newVal);
  }

  Future<void> saveCondition() async {
    try {
      final ids = _read(_uiStateProvider).selectConditionIds;
      final newRecord = Record.condition(
        id: recordId,
        conditions: _read(conditionsProvider).where((e) => ids.contains(e.id)).toList(),
        isWalking: _read(_uiStateProvider).isWalking,
        isToilet: _read(_uiStateProvider).isToilet,
        memo: _read(_uiStateProvider).conditionMemo,
      );
      await _read(recordRepositoryProvider).saveCondition(newRecord);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void selectMedicineIds(Set<int> newVal) {
    _read(_uiStateProvider.notifier).selectMedicineIds(newVal);
  }

  Future<void> saveMedicine() async {
    try {
      final medicineIds = _read(_uiStateProvider).selectMedicineIds;
      final idsStr = Record.setToMedicineIdsStr(medicineIds);
      await _read(recordRepositoryProvider).saveMedicineIds(recordId, idsStr);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  void inputMemo(String newVal) {
    _read(_uiStateProvider.notifier).inputMemo(newVal);
  }

  Future<void> saveMemo() async {
    try {
      final memo = _read(_uiStateProvider).memo;
      await _read(recordRepositoryProvider).saveMemo(recordId, memo);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

// 画面の状態
final _uiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(_UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(_UiState state) : super(state);

  void init(Record record) {
    state = _UiState(
      breakfast: record.breakfast ?? '',
      lunch: record.lunch ?? '',
      dinner: record.dinner ?? '',
      morningTemperature: record.morningTemperature ?? 0,
      nightTemperature: record.nightTemperature ?? 0,
      selectConditionIds: record.conditions.map((e) => e.id).toSet(),
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionMemo: record.conditionMemo ?? '',
      selectMedicineIds: record.medicines.map((e) => e.id).toSet(),
      memo: record.memo ?? '',
    );
  }

  void inputBreakfast(String newVal) {
    state = state.copyWith(breakfast: newVal);
  }

  void inputLunch(String newVal) {
    state = state.copyWith(lunch: newVal);
  }

  void inputDinner(String newVal) {
    state = state.copyWith(dinner: newVal);
  }

  void inputMorningTemperature(double newVal) {
    state = state.copyWith(morningTemperature: newVal);
  }

  void inputNightTemperature(double newVal) {
    state = state.copyWith(nightTemperature: newVal);
  }

  void selectConditionIds(Set<int> newVal) {
    state = state.copyWith(selectConditionIds: {...newVal});
  }

  void inputWalking(bool newVal) {
    state = state.copyWith(isWalking: newVal);
  }

  void inputToilet(bool newVal) {
    state = state.copyWith(isToilet: newVal);
  }

  void selectMedicineIds(Set<int> newVal) {
    state = state.copyWith(selectMedicineIds: {...newVal});
  }

  void inputMemo(String? newVal) {
    state = state.copyWith(memo: newVal);
  }
}

class _UiState {
  _UiState({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.morningTemperature,
    required this.nightTemperature,
    required this.selectConditionIds,
    required this.isWalking,
    required this.isToilet,
    required this.conditionMemo,
    required this.selectMedicineIds,
    required this.memo,
  });

  factory _UiState.empty() {
    return _UiState(
      breakfast: '',
      lunch: '',
      dinner: '',
      morningTemperature: 0,
      nightTemperature: 0,
      selectConditionIds: {},
      isWalking: false,
      isToilet: false,
      conditionMemo: '',
      selectMedicineIds: {},
      memo: '',
    );
  }

  final String breakfast;
  final String lunch;
  final String dinner;
  final double morningTemperature;
  final double nightTemperature;
  final Set<int> selectConditionIds;
  final bool isWalking;
  final bool isToilet;
  final String conditionMemo;
  final Set<int> selectMedicineIds;
  final String memo;

  _UiState copyWith({
    String? breakfast,
    String? lunch,
    String? dinner,
    double? morningTemperature,
    double? nightTemperature,
    Set<int>? selectConditionIds,
    bool? isWalking,
    bool? isToilet,
    String? conditionMemo,
    Set<int>? selectMedicineIds,
    String? memo,
  }) {
    return _UiState(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      morningTemperature: morningTemperature ?? this.morningTemperature,
      nightTemperature: nightTemperature ?? this.nightTemperature,
      selectConditionIds: selectConditionIds ?? this.selectConditionIds,
      isWalking: isWalking ?? this.isWalking,
      isToilet: isToilet ?? this.isToilet,
      conditionMemo: conditionMemo ?? this.conditionMemo,
      selectMedicineIds: selectMedicineIds ?? this.selectMedicineIds,
      memo: memo ?? this.memo,
    );
  }
}

final breakfastProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((v) => v.breakfast)));
final lunchProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((v) => v.lunch)));
final dinnerProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((v) => v.dinner)));
final morningTemperatureProvider = Provider<double>((ref) => ref.watch(_uiStateProvider.select((v) => v.morningTemperature)));
final nightTemperatureProvider = Provider<double>((ref) => ref.watch(_uiStateProvider.select((v) => v.nightTemperature)));
final selectConditionIdsProvider = Provider<Set<int>>((ref) => ref.watch(_uiStateProvider.select((v) => v.selectConditionIds)));
final isWalkingProvider = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((v) => v.isWalking)));
final isToiletProvider = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((v) => v.isToilet)));
final conditionMemoProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((v) => v.memo)));
final selectMedicineIdsProvider = Provider<Set<int>>((ref) => ref.watch(_uiStateProvider.select((v) => v.selectMedicineIds)));
final memoProvider = Provider<String?>((ref) => ref.watch(_uiStateProvider.select((v) => v.breakfast)));
