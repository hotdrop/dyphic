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

  Future<void> inputBreakfast({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveBreakFast(id, newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputLunch({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveLunch(id, newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputDinner({required int id, required String newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveDinner(id, newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputMorningTemperature({required int id, required double newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveMorningTemperature(id, newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputNightTemperature({required int id, required double newVal}) async {
    try {
      await _read(recordRepositoryProvider).saveNightTemperature(id, newVal);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('夜の体温の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveCondition({
    required int id,
    required Set<int> conditionIds,
    required bool isWalking,
    required bool isToilet,
    required String memo,
  }) async {
    try {
      final conditions = _read(conditionsProvider).where((e) => conditionIds.contains(e.id)).toList();
      final newRecord = Record.condition(
        id: id,
        conditions: conditions,
        isWalking: isWalking,
        isToilet: isToilet,
        memo: memo,
      );
      await _read(recordRepositoryProvider).saveCondition(newRecord);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveMedicine({required int id, required Set<int> medicineIds}) async {
    try {
      final idsStr = Record.setToMedicineIdsStr(medicineIds);
      await _read(recordRepositoryProvider).saveMedicineIds(id, idsStr);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveMemo({required int id, required String memo}) async {
    try {
      await _read(recordRepositoryProvider).saveMemo(id, memo);
      _read(calendarViewModelProvider).markRecordEditted();
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

final scrollPositionStateProvider = StateProvider<double>((ref) => 0);
