import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/calendar_event.dart';
import 'package:dalico/repository/local/event_database.dart';
import 'package:dalico/repository/remote/event_api.dart';

class EventRepository {
  const EventRepository._(this._api, this._eventDb);

  factory EventRepository.create() {
    return EventRepository._(EventApi.create(), EventDatabase.create());
  }

  final EventApi _api;
  final EventDatabase _eventDb;

  Future<List<Event>> findAll(AppSettings appSettings) async {
    final latestEvents = _api.findByLatest(appSettings);
    if (latestEvents.isNotEmpty) {
      await _eventDb.update(latestEvents);
    }
    return await _eventDb.findAll();
  }
}
