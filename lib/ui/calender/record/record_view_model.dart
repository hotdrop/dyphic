import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/calender/calendar_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/record.dart';

final recordViewModelProvider = Provider((ref) => _RecordViewModel(ref.read));

class _RecordViewModel {
  _RecordViewModel(this._read);

  final Reader _read;

  ///
  /// 左右にスワイプして戻るとこの引数のRecord情報が取れるので、Record情報の更新は全てModelクラスに集約した方が良さそう。
  ///
  Future<void> init(Record record) async {
    _read(breakfastStateProvider.notifier).state = record.breakfast ?? '';
    _read(lunchStateProvider.notifier).state = record.lunch ?? '';
    _read(dinnerStateProvider.notifier).state = record.dinner ?? '';
    _read(temperatureStateProvider.notifier).state = record.morningTemperature ?? 0;
    _read(conditionStateProvider.notifier).init(record);
    _read(medicineIdsStateProvider.notifier).init(record);
    _read(memoStateProvider.notifier).state = record.memo ?? '';
    _read(eventStateProvider.notifier).init(record);
  }

  Future<void> inputBreakfast({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveBreakFast(id, newVal);
      _read(breakfastStateProvider.notifier).state = newVal;
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputLunch({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveLunch(id, newVal);
      _read(lunchStateProvider.notifier).state = newVal;
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputDinner({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveDinner(id, newVal);
      _read(dinnerStateProvider.notifier).state = newVal;
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputMorningTemperature({required int id, required double newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveMorningTemperature(id, newVal);
      _read(temperatureStateProvider.notifier).state = newVal;
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveMemo({required int id}) async {
    try {
      await _read(recordRepositoryProvider).saveMemo(id, _read(memoStateProvider));
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

final scrollPositionStateProvider = StateProvider<double>((ref) => 0);

// 食事に関するProvider
final breakfastStateProvider = StateProvider<String>((ref) => '');
final lunchStateProvider = StateProvider<String>((ref) => '');
final dinnerStateProvider = StateProvider<String>((ref) => '');

// 体温に関するProvider
final temperatureStateProvider = StateProvider<double>((ref) => 0);

// 体調に関するProvider定義
final conditionStateProvider = StateNotifierProvider<_InputConditionNotifier, _InputCondition>((ref) {
  return _InputConditionNotifier(ref.read, _InputCondition.empty());
});

class _InputConditionNotifier extends StateNotifier<_InputCondition> {
  _InputConditionNotifier(this._read, _InputCondition state) : super(state);

  final Reader _read;

  void init(Record record) {
    state = _InputCondition(
      selectIds: record.conditions.map((e) => e.id).toSet(),
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionMemo: record.conditionMemo ?? '',
    );
  }

  void changeSelectIds(Set<int> newVal) {
    state = state.copyWith(selectIds: newVal);
  }

  void inputIsWalk(bool newVal) {
    state = state.copyWith(isWalking: newVal);
  }

  void inputIsToilet(bool newVal) {
    state = state.copyWith(isToilet: newVal);
  }

  void inputMemo(String newVal) {
    state = state.copyWith(conditionMemo: newVal);
  }

  Future<void> save(int id) async {
    try {
      final conditions = _read(conditionsProvider).where((e) => state.selectIds.contains(e.id)).toList();
      final newRecord = Record.condition(
        id: id,
        conditions: conditions,
        isWalking: state.isWalking,
        isToilet: state.isToilet,
        memo: state.conditionMemo,
      );
      await _read(recordRepositoryProvider).saveCondition(newRecord);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

class _InputCondition {
  _InputCondition({
    required this.selectIds,
    required this.isWalking,
    required this.isToilet,
    required this.conditionMemo,
  });

  final Set<int> selectIds;
  final bool isWalking;
  final bool isToilet;
  final String conditionMemo;

  factory _InputCondition.empty() {
    return _InputCondition(selectIds: {}, isWalking: false, isToilet: false, conditionMemo: '');
  }

  _InputCondition copyWith({Set<int>? selectIds, bool? isWalking, bool? isToilet, String? conditionMemo}) {
    return _InputCondition(
      selectIds: selectIds ?? this.selectIds,
      isWalking: isWalking ?? this.isWalking,
      isToilet: isToilet ?? this.isToilet,
      conditionMemo: conditionMemo ?? this.conditionMemo,
    );
  }
}

// お薬情報に関するProvider情報
final medicineIdsStateProvider = StateNotifierProvider<_SelectMedicineIdsNotifier, Set<int>>((ref) {
  return _SelectMedicineIdsNotifier(ref.read, {});
});

class _SelectMedicineIdsNotifier extends StateNotifier<Set<int>> {
  _SelectMedicineIdsNotifier(this._read, Set<int> state) : super(state);

  final Reader _read;

  void init(Record record) {
    state = record.medicines.map((e) => e.id).toSet();
  }

  void changeSelectIds(Set<int> newIds) {
    state = {...newIds};
  }

  Future<void> save(int id) async {
    try {
      final idsStr = Record.setToMedicineIdsStr(state);
      await _read(recordRepositoryProvider).saveMedicineIds(id, idsStr);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

// メモのProvider
final memoStateProvider = StateProvider<String>((ref) => '');

// イベントに関するProvider定義
final eventStateProvider = StateNotifierProvider<_InputEventNotifier, _InputEvent>((ref) {
  return _InputEventNotifier(ref.read, _InputEvent.empty());
});

class _InputEventNotifier extends StateNotifier<_InputEvent> {
  _InputEventNotifier(this._read, _InputEvent state) : super(state);

  final Reader _read;

  void init(Record record) {
    state = _InputEvent(eventType: record.eventType, eventName: record.eventName);
  }

  void inputType(EventType newVal) {
    state = state.copyWith(eventType: newVal);
  }

  void inputName(String newVal) {
    state = state.copyWith(eventName: newVal);
  }

  Future<void> save(int id) async {
    try {
      await _read(recordRepositoryProvider).saveEvent(id, state.eventType, state.eventName ?? '');
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('イベントの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

class _InputEvent {
  _InputEvent({required this.eventType, required this.eventName});

  final EventType eventType;
  final String? eventName;

  factory _InputEvent.empty() {
    return _InputEvent(eventType: EventType.none, eventName: null);
  }

  _InputEvent copyWith({EventType? eventType, String? eventName}) {
    return _InputEvent(
      eventType: eventType ?? this.eventType,
      eventName: eventName ?? this.eventName,
    );
  }
}
