import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/model/record.dart';

part 'calendar_provider.g.dart';

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
    for (final record in records) {
      recordsMap[record.id] = record;
      if (record.isSameDay(nowDate)) {
        ref.read(calendarSelectedRecordStateProvider.notifier).state = record;
      }
    }

    ref.read(calendarRecordsMapStateProvder.notifier).state = recordsMap;
  }

  List<Record> getRecordForDay(Map<int, Record> mapData, DateTime date) {
    final id = DyphicID.createId(date);
    final event = mapData[id];
    return event != null ? [event] : [];
  }

  void onDaySelected(DateTime selectDate, {Record? selectedItem}) {
    final id = DyphicID.createId(selectDate);
    ref.read(calendarSelectedRecordStateProvider.notifier).state = ref.read(calendarRecordsMapStateProvder)[id] ?? Record.createEmpty(selectDate);
    ref.read(calendarFocusDateStateProvider.notifier).state = selectDate;
    ref.read(calendarSelectedDateStateProvider.notifier).state = selectDate;
  }

  Future<void> refresh(int id) async {
    final updateRecord = await ref.read(recordRepositoryProvider).find(id);
    final newRecordsMap = {...ref.read(calendarRecordsMapStateProvder)};
    newRecordsMap[id] = updateRecord;
    ref.read(calendarRecordsMapStateProvder.notifier).state = newRecordsMap;
    ref.read(calendarSelectedRecordStateProvider.notifier).state = updateRecord;
  }

  void clearUpdateRecordFlag() {
    ref.read(updateEditRecordStateProvider.notifier).state = false;
  }
}

// カレンダーの記録データ
final calendarRecordsMapStateProvder = StateProvider<Map<int, Record>>((ref) => {});

// 選択した日付の記録データ
final calendarSelectedRecordStateProvider = StateProvider<Record>((ref) {
  return Record.createEmpty(DateTime.now());
});

// 選択した日付
final calendarSelectedDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());

// フォーカスが当たっている日付
final calendarFocusDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());

// 記録ページを更新したか保持する。このProviderはカレンダーではなくRecordContorller関連で設定されるので注意
final updateEditRecordStateProvider = StateProvider<bool>((_) => false);
