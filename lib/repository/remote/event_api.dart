import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/calendar_event.dart';

class EventApi {
  const EventApi._();

  factory EventApi.create() {
    return EventApi._();
  }

  List<Event> findByLatest(AppSettings appSettings) {
    // TODO storageのjson取得
    //  Firebase storageのjsonの更新日付を取得する。取得できなかったりログインしていなければ終了
    //  appSettingsで保持している日付 < 更新日付
    //    String json = await _service.readEventJson();
    //    return EventJson.parse(json)
    //  それ以外 []
    return [];
  }
}
