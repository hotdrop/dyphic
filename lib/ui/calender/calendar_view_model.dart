import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/event_repository.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late Map<int, CalendarEvent> _events;
  List<CalendarEvent> get calendarEvents => _events.values.toList();

  Future<void> _init() async {
    try {
      final events = await _read(eventRepositoryProvider).findAll();
      final overviewRecords = await _read(recordRepositoryProvider).findEventRecords();
      _events = _merge(events, overviewRecords);
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('カレンダー情報の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  Map<int, CalendarEvent> _merge(List<Event> events, List<RecordOverview> records) {
    final Map<int, Event> eventMap = Map.fromIterables(events.map((e) => e.id), events.map((e) => e));
    final Map<int, CalendarEvent> results = {};

    // レコードをベースにイベントをマージする
    for (var r in records) {
      if (eventMap.containsKey(r.recordId)) {
        final Event event = eventMap[r.recordId]!;
        results[r.recordId] = CalendarEvent.create(event, r);
      } else {
        results[r.recordId] = CalendarEvent.createOnlyRecord(r);
      }
    }

    // レコードに入っていないイベントをマージする
    for (var e in events) {
      if (!results.containsKey(e.id)) {
        results[e.id] = (CalendarEvent.createOnlyEvent(e));
      }
    }

    return results;
  }

  Future<void> refresh(int updateId) async {
    try {
      final recordOverview = await _read(recordRepositoryProvider).findOverview(updateId);
      if (recordOverview == null) {
        // 通常、refresh時に対象となるupdateIdのrecordOverviewがnullになるとはないが、
        // 何らかの理由でデータが書き込めていないとかネットワーク障害でデータを取得できなかった場合はnullになる可能性がある。
        // その場合はrefreshせずに終了する。
        return;
      }

      if (_events.containsKey(recordOverview.recordId)) {
        final existEventWithNewRecord = _events[recordOverview.recordId]!.updateRecord(recordOverview);
        _events[recordOverview.recordId] = existEventWithNewRecord;
      } else {
        final newEvent = CalendarEvent.createOnlyRecord(recordOverview);
        _events[recordOverview.recordId] = newEvent;
      }

      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('カレンダー情報の更新に失敗しました。', e, s);
      onError('$e');
    }
  }
}
