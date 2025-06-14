import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/model/record.dart';

part 'calendar_controller.g.dart';

@riverpod
class CalendarController extends _$CalendarController {
  @override
  Future<void> build() async {
    await onLoadRecords();
  }

  Future<void> onLoadRecords() async {
    final records = await ref.read(recordRepositoryProvider).findAll();
    final recordsMap = <int, Record>{};
    final nowDate = DateTime.now();
    ref.read(calendarSelectedDateStateProvider.notifier).state = nowDate;
    for (final record in records) {
      recordsMap[record.id] = record;
    }
    ref.read(calendarRecordsMapStateProvder.notifier).state = recordsMap;
  }

  List<Record> getRecordForDay(Map<int, Record> mapData, DateTime date) {
    final id = DyphicID.createId(date);
    final event = mapData[id];
    return event != null ? [event] : [];
  }

  void onDaySelected(DateTime selectDate, {Record? selectedItem}) {
    ref.read(calendarSelectedDateStateProvider.notifier).state = selectDate;
    ref.read(calendarFocusDateStateProvider.notifier).state = selectDate;
  }

  bool isSelectedAfterToday() {
    final selectedDate = ref.read(calendarSelectedDateStateProvider);
    final now = DateTime.now();
    return selectedDate.isAfter(now);
  }

  ///
  /// 記録画面で左右にスワイプするとカレンダー画面に戻らなくても過去日付の記録画面が見れる
  /// 最大で前後1ヶ月をスワイプできるようにする
  ///
  List<int> createSwipeRangeRecordIds() {
    final selectedDate = ref.read(calendarSelectedDateStateProvider);

    final startDate = DateUtils.addMonthsToMonthDate(selectedDate, -1);
    // 終了日は最大で当日まで。1ヶ月後が当日以降の場合は当日までのIdを作る
    // これにより、未来へのスワイプは今日までしかできなくなる
    final oneMonthLater = DateUtils.addMonthsToMonthDate(selectedDate, 1);
    final now = DateTime.now();
    final endDate = oneMonthLater.isAfter(now) ? now : oneMonthLater;

    // 選択日の前後1ヶ月のIDリストを生成する
    final recordIds = <int>[];
    for (var date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      recordIds.add(DyphicID.createId(date));
    }

    return recordIds;
  }

  Future<void> refresh(int id) async {
    final updateRecord = await ref.read(recordRepositoryProvider).find(id);
    final newRecordsMap = {...ref.read(calendarRecordsMapStateProvder)};
    // リフレッシュで指定されたidは必ず存在する前提
    newRecordsMap[id] = updateRecord!;
    ref.read(calendarRecordsMapStateProvder.notifier).state = newRecordsMap;
    ref.read(calendarSelectedDateStateProvider.notifier).state = DyphicID.idToDate(id);
  }

  void clearUpdateRecordFlag() {
    ref.read(updateEditRecordStateProvider.notifier).state = false;
  }
}

// カレンダーの記録データ
final calendarRecordsMapStateProvder = StateProvider<Map<int, Record>>((ref) => {});

// 選択した日付
final calendarSelectedDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());

// 選択した日付の記録データ
final calendarSelectedRecordStateProvider = Provider<Record>((ref) {
  final selectDate = ref.watch(calendarSelectedDateStateProvider);
  final recordsMap = ref.watch(calendarRecordsMapStateProvder);
  final targetId = DyphicID.dateToId(selectDate);
  return recordsMap[targetId] ?? Record.createEmptyForDate(DateTime.now());
});

// フォーカスが当たっている日付
final calendarFocusDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());

// 記録ページを更新したか保持する。このProviderはカレンダーではなくRecordContorller関連で設定されるので注意
final updateEditRecordStateProvider = StateProvider<bool>((_) => false);
