import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/record.dart';

class RecordApi {
  const RecordApi._();

  factory RecordApi.create() {
    return RecordApi._();
  }

  Future<List<EventRecord>> findIds() async {
    // TODO FirestoreからIDとdateだけ取得する。接続できない場合は空を返す
    return [
      EventRecord(date: DateTime(2021, 2, 10)),
      EventRecord(date: DateTime(2021, 2, 11)),
    ];
  }

  Future<Record> find(DateTime date) async {
    // TODO Firestoreから該当IDの記録情報を取得
    final id = Record.makeRecordId(date);
    final getMedicines = [
      Medicine(name: 'テスト薬', isOral: false, order: 4),
      Medicine(name: 'ビオフェルミン', isOral: false, order: 2, memo: 'お腹が痛い時に飲む'),
      Medicine(name: 'キャベジン', isOral: false, order: 1, memo: '胃腸薬です。'),
      Medicine(name: 'キャベジンS', isOral: false, order: 3),
    ];
    getMedicines.sort((a, b) => a.order - b.order);
    return Record(
      date: DateTime(2021, 2, 20),
      cycle: 2,
      morningTemperature: 36.5,
      nightTemperature: 36.7,
      medicines: getMedicines,
      conditions: ['頭痛', '倦怠感', '便秘'],
      conditionMemo: '便秘は7日目・・',
      breakfast: 'パン',
      lunch: 'うどん',
      dinner: '鍋',
      memo: 'アイウエオ',
    );
  }

  Future<void> save(Record record) async {
    // TODO Firestoreへ保存
  }

  Future<void> update(Record record) async {
    // TODO Firestoreの既存情報を更新
  }
}
