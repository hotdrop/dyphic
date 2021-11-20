import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/repository/local/dao/event_dao.dart';
import 'package:dyphic/repository/local/shared_prefs.dart';
import 'package:dyphic/repository/remote/event_api.dart';

final eventRepositoryProvider = Provider((ref) => _EventRepository(ref.read));

class _EventRepository {
  const _EventRepository(this._read);

  final Reader _read;

  Future<DateTime?> getPreviousLoadEventDate() async {
    return await _read(sharedPrefsProvider).getPrevSaveEventDate();
  }

  Future<List<Event>> findAll() async {
    final events = await _read(eventDaoProvider).findAll();
    if (events.isNotEmpty) {
      return events;
    }

    await refresh();
    return await _read(eventDaoProvider).findAll();
  }

  Future<void> refresh() async {
    final events = await _read(eventApiProvider).findAll();
    await _read(eventDaoProvider).saveAll(events);
    await _read(sharedPrefsProvider).savePreviousGetEventDate(DateTime.now());
  }
}
