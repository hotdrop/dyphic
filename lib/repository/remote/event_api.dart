import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/shared_prefs.dart';
import 'package:dyphic/repository/remote/response/event_response.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventApiProvider = Provider((ref) => _EventApi(ref.read));

class _EventApi {
  const _EventApi(this._read);

  final Reader _read;

  Future<bool> isNewEvent() async {
    final prevSaveEventDate = await _read(sharedPrefsProvider).getPrevSaveEventDate();
    return await _read(appFirebaseProvider).isUpdateEventJson(prevSaveEventDate);
  }

  Future<List<Event>> findAll() async {
    final responseRow = await _read(appFirebaseProvider).readEventJson() as Map<String, dynamic>;
    final response = EventsResponse.fromJson(responseRow);
    return response.events.map((r) => _toEvent(r)).toList();
  }

  Event _toEvent(EventResponse response) {
    final type = Event.toType(response.typeIdx);
    return Event(id: response.id, type: type, name: response.name);
  }
}
