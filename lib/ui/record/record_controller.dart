import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/calender/calendar_controller.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/record.dart';

part 'record_controller.g.dart';

@riverpod
class RecordController extends _$RecordController {
  @override
  void build() {}

  Future<Record> find(int id) async {
    // 体調情報のマスターデータがロードされていなければここで行う
    final currentC = ref.read(conditionsStateProvier);
    if (currentC.isEmpty) {
      final conditions = await ref.read(conditionRepositoryProvider).findAll();
      ref.read(conditionsStateProvier.notifier).state = conditions;
    }
    final record = await ref.read(recordRepositoryProvider).find(id);
    if (record != null) {
      return record;
    } else {
      return Record.createEmpty(id);
    }
  }

  Future<List<Medicine>> fetchMedicines() async {
    return await ref.read(medicineRepositoryProvider).findAll();
  }

  Future<void> inputBreakfast({required int id, required String newVal}) async {
    try {
      await ref.read(recordRepositoryProvider).saveBreakFast(id, newVal);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('朝食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputLunch({required int id, required String newVal}) async {
    try {
      await ref.read(recordRepositoryProvider).saveLunch(id, newVal);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('昼食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputDinner({required int id, required String newVal}) async {
    try {
      await ref.read(recordRepositoryProvider).saveDinner(id, newVal);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('夕食の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> inputMorningTemperature({required int id, required double newVal}) async {
    try {
      await ref.read(recordRepositoryProvider).saveMorningTemperature(id, newVal);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('朝の体温の保存に失敗しました。', e, s);
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
      final allConditions = await ref.read(conditionRepositoryProvider).findAll();
      final conditions = allConditions.where((e) => conditionIds.contains(e.id)).toList();
      final newRecord = Record.condition(
        id: id,
        conditions: conditions,
        isWalking: isWalking,
        isToilet: isToilet,
        memo: memo,
      );
      await ref.read(recordRepositoryProvider).saveCondition(newRecord);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('体調情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveMedicine({required int id, required Set<int> medicineIds}) async {
    try {
      final idsStr = Record.setToMedicineIdsStr(medicineIds);
      await ref.read(recordRepositoryProvider).saveMedicineIds(id, idsStr);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('選択したお薬の保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveMemo({required int id, required String memo}) async {
    try {
      await ref.read(recordRepositoryProvider).saveMemo(id, memo);
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('メモの保存に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> saveEvent({
    required int id,
    required EventType eventType,
    required String? eventName,
  }) async {
    try {
      await ref.read(recordRepositoryProvider).saveEvent(id, eventType, eventName ?? '');
      ref.read(updateEditRecordStateProvider.notifier).state = true;
    } catch (e, s) {
      await AppLogger.e('イベントの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

// スクロール位置を保持する
final scrollPositionStateProvider = StateProvider<double>((ref) => 0);

// 現在、アプリにサインインしているか？
final isSignInProvider = Provider((ref) => ref.read(accountRepositoryProvider).isSignIn);

final conditionsStateProvier = StateProvider<List<Condition>>((_) => []);
