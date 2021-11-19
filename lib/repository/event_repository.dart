import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/dao/event_dao.dart';
import 'package:dyphic/repository/local/shared_prefs.dart';
import 'package:dyphic/repository/remote/event_api.dart';

final eventRepositoryProvider = Provider((ref) => _EventRepository(ref.read));

class _EventRepository {
  const _EventRepository(this._read);

  final Reader _read;

  Future<List<Event>> findAll() async {
    final isNewEvent = await _read(eventApiProvider).isNewEvent();
    AppLogger.d('イベント情報更新が必要か？ $isNewEvent');

    if (isNewEvent) {
      AppLogger.d('新しいイベント情報があるので更新する');
      final events = await _read(eventApiProvider).findAll();
      await _read(eventDaoProvider).saveAll(events);
      await _read(sharedPrefsProvider).savePreviousGetEventDate(DateTime.now());
    }

    final events = await _read(eventDaoProvider).findAll();
    return events;
  }
}
