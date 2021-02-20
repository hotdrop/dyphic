import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/event_database.dart';
import 'package:dyphic/repository/remote/event_api.dart';

class EventRepository {
  const EventRepository._(this._eventApi, this._eventDb);

  factory EventRepository.create() {
    return EventRepository._(EventApi.create(), EventDatabase.create());
  }

  final EventApi _eventApi;
  final EventDatabase _eventDb;

  Future<List<Event>> findAll(AppSettings appSettings) async {
    final latestEvents = await _eventApi.findByLatest(appSettings);
    if (latestEvents.isNotEmpty) {
      await _eventDb.update(latestEvents);
    }
    return await _eventDb.findAll();
  }
}
