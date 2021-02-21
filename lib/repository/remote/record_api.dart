import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/condition.dart';
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
    final getMedicines = [
      Medicine(name: 'テスト薬その2', isOral: false, order: 4),
      Medicine(name: '酸化マグネシウム', isOral: false, order: 3),
    ];
    return Record(
      date: DateTime(2021, 2, 20),
      cycle: 2,
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
  }

  Future<void> save(Record record) async {
    // TODO Firestoreへ保存
  }

  Future<void> update(Record record) async {
    // TODO Firestoreの既存情報を更新
  }
}
