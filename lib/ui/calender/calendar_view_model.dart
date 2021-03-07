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

  Map<int, CalendarEvent> _events;
  List<CalendarEvent> get calendarEvents => _events.values.toList();

  Future<void> _init() async {
    final events = await _eventRepository.findAll();
    final overviewRecords = await _recordRepository.findEventRecords();
    _events = _merge(events, overviewRecords);
    loadSuccess();
  }

  Map<int, CalendarEvent> _merge(List<Event> events, List<RecordOverview> overviewRecords) {
    Map<int, Event> eventMap = Map.fromIterables(events.map((e) => e.id), events.map((e) => e));
    Map<int, CalendarEvent> results = {};

    // レコードをベースにイベントをマージする
    overviewRecords.forEach((overviewRecord) {
      if (eventMap.containsKey(overviewRecord.recordId)) {
        final event = eventMap[overviewRecord.recordId];
        results[overviewRecord.recordId] = CalendarEvent.create(event, overviewRecord);
      } else {
        results[overviewRecord.recordId] = CalendarEvent.createOnlyRecord(overviewRecord);
      }
    });

    // レコードに入っていないイベントをマージする
    events.forEach((event) {
      if (!results.containsKey(event.id)) {
        results[event.id] = (CalendarEvent.createOnlyEvent(event));
      }
    });

    return results;
  }

  Future<void> refresh(int updateId) async {
    nowLoading();
    final record = await _recordRepository.findById(updateId);
    final recordOverview = RecordOverview.fromRecord(record);

    if (_events.containsKey(recordOverview.recordId)) {
      final existEventWithNewRecord = _events[recordOverview.recordId].updateRecord(recordOverview);
      _events[recordOverview.recordId] = existEventWithNewRecord;
    } else {
      final newEvent = CalendarEvent.createOnlyRecord(recordOverview);
      _events[recordOverview.recordId] = newEvent;
    }

    loadSuccess();
  }
}
