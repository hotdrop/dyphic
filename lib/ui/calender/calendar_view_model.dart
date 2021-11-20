import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    try {
      // final events = await _read(eventRepositoryProvider).findAll();
      await _read(recordsProvider.notifier).onLoad();
      // _events = _merge(_read(recordsProvider), events);
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('カレンダー情報の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  // Map<int, CalendarEvent> _merge(List<Record> records, List<Event> events) {
  //   final Map<int, Event> eventMap = Map.fromIterables(events.map((e) => e.id), events.map((e) => e));
  //   final Map<int, CalendarEvent> results = {};

  //   // レコードをベースにイベントをマージする
  //   for (var r in records) {
  //     if (eventMap.containsKey(r.id)) {
  //       final Event event = eventMap[r.id]!;
  //       results[r.id] = CalendarEvent.create(event, r);
  //     } else {
  //       results[r.id] = CalendarEvent.createOnlyRecord(r);
  //     }
  //   }

  //   // レコードに入っていないイベントをマージする
  //   for (var e in events) {
  //     if (!results.containsKey(e.id)) {
  //       results[e.id] = (CalendarEvent.createOnlyEvent(e));
  //     }
  //   }

  //   return results;
  // }

  // Future<void> refresh(int id) async {
  //   try {
  //     final record = _read(recordsProvider).firstWhereOrNull((r) => r.id == id);
  //     if (record == null) {
  //       return;
  //     }

  //     if (_events.containsKey(record.id)) {
  //       final existEventWithNewRecord = _events[record.id]!.updateRecord(record);
  //       _events[record.id] = existEventWithNewRecord;
  //     } else {
  //       final newEvent = CalendarEvent.createOnlyRecord(record);
  //       _events[record.id] = newEvent;
  //     }

  //     notifyListeners();
  //   } catch (e, s) {
  //     await AppLogger.e('カレンダー情報の更新に失敗しました。', e, s);
  //     onError('$e');
  //   }
  // }
}
