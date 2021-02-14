import 'package:dalico/model/medicine.dart';

class MedicineApi {
  const MedicineApi._();

  factory MedicineApi.create() {
    return MedicineApi._();
  }

  Future<List<Medicine>> findAll() async {
    // TODO Firestoreから取得
    //  Firebase storageのjsonの更新日付を取得する。取得できなかったりログインしていなければ終了
    //  appSettingsで保持している日付 < 更新日付
    //    String json = await _service.readMedicineJson();
    //    return MedicineJson.parse(json)
    //  それ以外 []
    return [
      Medicine(name: '酸化マグネシウム', isOral: false, memo: '便に水分を与える下剤\\n便に水分を届けるため180mlくらいの多量の水と一緒に服用する。'),
      Medicine(name: '内服薬その1', isOral: true, memo: '炎症を抑える。朝食後に飲む。'),
      Medicine(name: '内服薬その2', isOral: true, memo: '朝昼晩、毎食後30分以内に飲む。\\n調べてみたら、胃を荒らすわけではないので30分以上経ってても良さそう。'),
      Medicine(name: 'テスト薬その1', isOral: false, memo: '抗生物質\\n発熱が37.5以上の場合に服用。これによって副作用が起こることはなさそう。'),
      Medicine(name: 'テスト薬その2', isOral: false, memo: '胃が痛くなった時に飲む。'),
    ];
  }
}
