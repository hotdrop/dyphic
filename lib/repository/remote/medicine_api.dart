import 'package:dyphic/model/medicine.dart';

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
    List<Medicine> dummyList = [
      Medicine(name: '酸化マグネシウム', isOral: false, order: 3, memo: '便に水分を与える下剤\n便に水分を届けるため180mlくらいの多量の水と一緒に服用する。'),
      Medicine(name: '内服薬その1', isOral: true, order: 2, memo: '炎症を抑える。朝食後に飲む。'),
      Medicine(name: '内服薬その2', isOral: true, order: 5, memo: '朝昼晩、毎食後30分以内に飲む。\n調べてみたら、胃を荒らすわけではないので30分以上経ってても良さそう。'),
      Medicine(name: 'テスト薬その1', isOral: false, order: 1, memo: '抗生物質\n発熱が37.5以上の場合に服用。これによって副作用が起こることはなさそう。'),
      Medicine(name: 'テスト薬その2', isOral: false, order: 4, memo: '胃が痛くなった時に飲む。'),
    ];
    dummyList.sort((a, b) => a.order - b.order);
    return dummyList;
  }

  Future<void> save(Medicine medicine) async {
    // TODO Firestoreへ保存
  }
}
