import 'package:dyphic/model/calendar_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventDaoProvider = Provider((ref) => const _EventDao());

class _EventDao {
  const _EventDao();

  Future<List<Event>> findAll() async {
    // TODO イベントデータを取得
    throw UnimplementedError();
  }

  Future<void> update(List<Event> events) async {
    // イベントデータ更新
    throw UnimplementedError();
  }
}
