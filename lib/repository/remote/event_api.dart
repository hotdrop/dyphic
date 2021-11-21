import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/event.dart';
import 'package:dyphic/repository/remote/response/event_response.dart';
import 'package:dyphic/service/app_firebase.dart';

final eventApiProvider = Provider((ref) => _EventApi(ref.read));

class _EventApi {
  const _EventApi(this._read);

  final Reader _read;

  Future<List<Event>> findAll() async {
    AppLogger.d('サーバーからイベントを全取得します。');
    final responseRow = await _read(appFirebaseProvider).readEventJson() as Map<String, dynamic>;
    final response = EventsResponse.fromJson(responseRow);
    return response.events.map((r) => _toEvent(r)).toList();
  }

  Event _toEvent(EventResponse response) {
    final type = Event.toType(response.typeIdx);
    return Event(id: response.id, type: type, name: response.name);
  }
}
