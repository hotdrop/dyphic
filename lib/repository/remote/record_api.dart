import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/record.dart';

class RecordApi {
  const RecordApi._();

  factory RecordApi.create() {
    return RecordApi._();
  }

  Future<List<EventRecord>> findIds() async {
    // TODO FirestoreからIDとdateだけ取得する。接続できない場合は空を返す
    return [
      EventRecord(date: DateTime(2021, 2, 10), recordId: 1),
      EventRecord(date: DateTime(2021, 2, 11), recordId: 2),
    ];
  }

  Future<Record> find(int id) async {
    // TODO Firestoreから該当IDの記録情報を取得
  }

  Future<void> save(Record record) async {
    // TODO Firestoreへ保存
  }

  Future<void> update(Record record) async {
    // TODO Firestoreの既存情報を更新
  }
}
