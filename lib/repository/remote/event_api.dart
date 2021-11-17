import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/json/event_json.dart';
import 'package:dyphic/repository/local/shared_prefs.dart';
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
    String json = await _read(appFirebaseProvider).readEventJson();
    return EventJson.parse(json);
  }
}
