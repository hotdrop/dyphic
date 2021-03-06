import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/service/app_firebase.dart';

class MedicineApi {
  const MedicineApi._(this._appFirebase);

  factory MedicineApi.create() {
    return MedicineApi._(AppFirebase.getInstance());
  }

  final AppFirebase _appFirebase;

  Future<List<Medicine>> findAll() async {
    // TODO Firestoreから取得
    //    String json = await _service.readMedicineJson();
    //    return MedicineJson.parse(json)
    //  それ以外 []

    final medicines = [
      Medicine(name: '酸化マグネシウム', overview: '便に水分を与える下剤', type: MedicineType.notOral, order: 3, memo: '便に水分を届けるため180mlくらいの多量の水と一緒に服用する。'),
      Medicine(name: '内服薬その1', overview: '炎症を抑える', type: MedicineType.oral, order: 2, memo: '熱が出たときに飲む薬。炎症を抑える効果があるようだ。朝食後に飲む。'),
      Medicine(name: '内服薬その2', overview: '胃薬弱いやつ', type: MedicineType.oral, order: 5, memo: '朝昼晩、毎食後30分以内に飲む。調べてみたら、胃を荒らすわけではないので30分以上経ってても良さそう。'),
      Medicine(name: 'テスト薬その1', overview: '抗生物質', type: MedicineType.notOral, order: 1, memo: '発熱が37.5以上の場合に服用。これによって副作用が起こることはなさそう。'),
      Medicine(name: 'テスト薬その2', overview: '胃腸薬', type: MedicineType.notOral, order: 4, memo: '胃が痛くなった時に飲む。'),
    ];
    // final medicines = <Medicine>[];

    medicines.sort((a, b) => a.order - b.order);
    AppLogger.d('お薬情報を全て取得しました。データ数: ${medicines.length}');

    return medicines;
  }

  Future<void> save(Medicine medicine) async {
    final saveUrl = await _appFirebase.saveImage(medicine.imagePath);
    final newMedicine = medicine.copy(imageUrl: saveUrl);
    // TODO Firestoreへ保存
    AppLogger.d('お薬情報を保存します。\n${newMedicine.toString()}');
  }
}
