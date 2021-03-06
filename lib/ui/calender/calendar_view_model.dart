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

  List<CalendarEvent> _events;
  List<CalendarEvent> get calendarEvents => _events;

  Future<void> _init() async {
    final events = await _eventRepository.findAll();
    final recordIds = await _recordRepository.findEventRecords();
    _events = _merge(events, recordIds);
    loadSuccess();
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
