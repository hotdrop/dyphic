import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/json/event_json.dart';
import 'package:dyphic/service/app_firebase.dart';

class EventApi {
  const EventApi._(this._appFirebase);

  factory EventApi.create() {
    return EventApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<Event>> findByLatest(DateTime prevSaveEventDate) async {
    if (!_appFirebase.isLogIn) {
      AppLogger.d('ログインしていないのでイベント取得は行いません。');
      return [];
    }

    final isUpdate = await _appFirebase.isUpdateEventJson(prevSaveEventDate);
    AppLogger.d('イベント情報更新が必要か？ $isUpdate');

    if (!isUpdate) {
      return [];
    }

    String json = await _appFirebase.readEventJson();
    return EventJson.parse(json);
  }
}
