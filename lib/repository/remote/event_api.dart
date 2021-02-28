import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/service/app_firebase.dart';

class EventApi {
  const EventApi._(this._appFirebase);

  factory EventApi.create({AppFirebase argFirebase}) {
    final firebase = argFirebase ?? AppFirebase.getInstance();
    return EventApi._(firebase);
  }

  final AppFirebase _appFirebase;

  Future<List<Event>> findByLatest(DateTime prevSaveEventDate) async {
    // TODO storageのjson取得
    //  Firebase storageのjsonの更新日付を取得する。取得できなかったりログインしていなければ終了
    //  appSettingsで保持している日付 < 更新日付
    //    String json = await _service.readEventJson();
    //    return EventJson.parse(json)
    //  それ以外 []
    AppLogger.d('Storageからイベント情報を取得しました。イベント数: 0');
    return [];
  }
}
