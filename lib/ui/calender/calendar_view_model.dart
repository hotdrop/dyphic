import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/notifier_view_model.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/event_repository.dart';
import 'package:dyphic/repository/record_repository.dart';

class CalendarViewModel extends NotifierViewModel {
  CalendarViewModel._(this._recordRepository, this._eventRepository) {
    _init();
  }

  factory CalendarViewModel.create() {
    return CalendarViewModel._(RecordRepository.create(), EventRepository.create());
  }

  final RecordRepository _recordRepository;
  final EventRepository _eventRepository;

  Map<DateTime, CalendarEvent> _events;
  List<CalendarEvent> get calendarEvents => _events.values.toList();

  Future<void> _init() async {
    final events = await _eventRepository.findAll();
    final overviewRecords = await _recordRepository.findEventRecords();
    _events = _merge(events, overviewRecords);
    loadSuccess();
  }

  Map<DateTime, CalendarEvent> _merge(List<Event> events, List<RecordOverview> overviewRecords) {
    Map<DateTime, Event> eventMap = Map.fromIterables(events.map((e) => e.date), events.map((e) => e));
    Map<DateTime, CalendarEvent> results = {};

    // レコードをベースにイベントをマージする
    overviewRecords.forEach((record) {
      if (eventMap.containsKey(record.date)) {
        final event = eventMap[record.date];
        results[record.date] = CalendarEvent.create(event, record);
      } else {
        results[record.date] = CalendarEvent.createOnlyRecord(record);
      }
    });

    // レコードに入っていないイベントをマージする
    events.forEach((event) {
      if (!results.containsKey(event.date)) {
        results[event.date] = (CalendarEvent.createOnlyEvent(event));
      }
    });

    return results;
  }

  Future<void> refresh(int updateId) async {
    nowLoading();
    final record = await _recordRepository.findById(updateId);

    final recordOverview = RecordOverview.fromRecord(record);
    if (_events.containsKey(recordOverview.date)) {
      final existEventWithNewRecord = _events[recordOverview.date].updateRecord(recordOverview);
      _events[recordOverview.date] = existEventWithNewRecord;
    } else {
      final newEvent = CalendarEvent.createOnlyRecord(recordOverview);
      _events[recordOverview.date] = newEvent;
    }

    loadSuccess();
  }
}
