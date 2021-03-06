import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/event_data_source.dart';
import 'package:dyphic/repository/local/app_data_source.dart';
import 'package:dyphic/repository/remote/event_api.dart';

class EventRepository {
  const EventRepository._(this._eventApi, this._eventDb, this._prefs);

  factory EventRepository.create() {
    return EventRepository._(EventApi.create(), EventDataSource.create(), AppDataSource.getInstance());
  }

  final EventApi _eventApi;
  final EventDataSource _eventDb;
  final AppDataSource _prefs;

  Future<List<Event>> findAll() async {
    final prevSaveEventDate = await _prefs.getPrevSaveEventDate();
    final latestEvents = await _eventApi.findByLatest(prevSaveEventDate);

    if (latestEvents.isNotEmpty) {
      await _eventDb.update(latestEvents);
      await _prefs.saveSaveGetEventDate();
    }

    return await _eventDb.findAll();
  }
}
