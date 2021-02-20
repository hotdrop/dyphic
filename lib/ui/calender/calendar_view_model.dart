import 'package:dyphic/model/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/repository/event_repository.dart';
import 'package:dyphic/repository/record_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel._(this._recordRepository, this._eventRepository);

  factory CalendarViewModel.create() {
    return CalendarViewModel._(RecordRepository.create(), EventRepository.create());
  }

  RecordRepository _recordRepository;
  EventRepository _eventRepository;

  PageState pageState = PageNowLoading();
  List<CalendarEvent> _events;
  List<CalendarEvent> get calendarEvents => _events;

  Future<void> init(AppSettings appSettings) async {
    _nowLoading();
    final events = await _eventRepository.findAll(appSettings);
    final recordIds = await _recordRepository.findIds();
    _events = _merge(events, recordIds);
    _loadSuccess();
  }

  void _nowLoading() {
    pageState = PageNowLoading();
    notifyListeners();
  }

  void _loadSuccess() {
    pageState = PageLoaded();
    notifyListeners();
  }

  List<CalendarEvent> _merge(List<Event> events, List<EventRecord> eventRecords) {
    final eventMap = Map.fromIterables(events.map((e) => e.date), events.map((e) => e));
    final addedEventMap = <DateTime, bool>{};
    List<CalendarEvent> results = [];

    // レコードをベースにイベントをマージする
    eventRecords.forEach((record) {
      if (eventMap.containsKey(record.date)) {
        final event = eventMap[record.date];
        addedEventMap[record.date] = true;
        results.add(CalendarEvent.create(event, record));
      } else {
        results.add(CalendarEvent.createOnlyRecord(record));
      }
    });

    // レコードに入っていないイベントをマージする
    events.forEach((event) {
      if (!addedEventMap.containsKey(event.date)) {
        results.add(CalendarEvent.createOnlyEvent(event));
      }
    });

    return results;
  }
}
