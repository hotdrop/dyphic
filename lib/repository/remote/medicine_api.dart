import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/medicine.dart';

class MedicineApi {
  const MedicineApi._();

  factory MedicineApi.create() {
    return MedicineApi._();
  }

  Future<List<Medicine>> findByLatest(AppSettings appSettings) async {
    // TODO storageのjson取得
    //  Firebase storageのjsonの更新日付を取得する。取得できなかったりログインしていなければ終了
    //  appSettingsで保持している日付 < 更新日付
    //    String json = await _service.readMedicineJson();
    //    return MedicineJson.parse(json)
    //  それ以外 []
    return [];
  }
}
