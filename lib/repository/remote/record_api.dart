import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/service/app_firebase.dart';

class RecordApi {
  const RecordApi._(this._appFirebase);

  factory RecordApi.create({AppFirebase argFirebase}) {
    final firebase = argFirebase ?? AppFirebase.getInstance();
    return RecordApi._(firebase);
  }

  final AppFirebase _appFirebase;

  Future<List<EventRecord>> findEventRecords() async {
    // TODO Firestoreから必要なデータのみ取得する。接続できない場合は空を返す
    final eventRecords = [
      EventRecord(
        date: DateTime(2021, 2, 10),
        conditions: ['腹痛', '胃痛', '筋肉痛'],
        medicines: ['ビオフェルミン', 'キャベジン'],
        memo: null,
      ),
      EventRecord(
        date: DateTime(2021, 2, 11),
        conditions: ['腹痛'],
        medicines: ['ビオフェルミン'],
        memo: 'アイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオ',
      ),
    ];
    AppLogger.d('記録情報が登録された日付を全て取得しました。登録数: ${eventRecords.length}');
    return eventRecords;
  }

  Future<Record> find(DateTime date) async {
    AppLogger.d('${Record.makeRecordId(date)} の記録情報を取得します。本当はここでFirestoreへ情報をとりに行きます。');

    // TODO Firestoreから該当IDの記録情報を取得
    final nowDate = DateTime.now();
    if (date.isBefore(nowDate)) {
      final getMedicines = [
        Medicine(name: 'テスト薬その2', isOral: false, order: 4),
        Medicine(name: '酸化マグネシウム', isOral: false, order: 3),
      ];
      return Record(
        date: DateTime(2021, 2, 20),
        morningTemperature: 36.5,
        nightTemperature: 36.7,
        medicines: getMedicines,
        conditions: [Condition(1, '頭痛'), Condition(3, '倦怠感'), Condition(4, '便秘')],
        conditionMemo: '便秘は7日目・・',
        breakfast: 'パン',
        lunch: 'うどん',
        dinner: '鍋',
        memo: 'アイウエオ',
      );
    } else {
      return null;
    }
  }

  Future<void> save(Record record) async {
    // TODO Firestoreへ保存
    AppLogger.d('${record.date} の記録情報を保存します。\n${record.toString()}');
  }
}
