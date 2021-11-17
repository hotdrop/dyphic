import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recordApiProvider = Provider((ref) => _RecordApi(ref.read));

class _RecordApi {
  const _RecordApi(this._read);

  final Reader _read;

  Future<List<RecordOverview>> findOverviewRecords() async {
    return await _read(appFirebaseProvider).findOverviewRecords();
  }

  Future<RecordOverview?> findOverviewRecord(int id) async {
    return await _read(appFirebaseProvider).findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    AppLogger.d('$id の記録情報を取得します。');
    final RecordOverview? overview = await _read(appFirebaseProvider).findOverviewRecord(id);
    final RecordTemperature? temperature = await _read(appFirebaseProvider).findTemperatureRecord(id);
    final RecordDetail? detail = await _read(appFirebaseProvider).findDetailRecord(id);

    final record = Record.create(
      id: id,
      recordOverview: overview,
      recordTemperature: temperature,
      recordDetail: detail,
    );
    return record;
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    AppLogger.d('$recordId の朝食を保存します。');
    await _read(appFirebaseProvider).saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    AppLogger.d('$recordId の昼食を保存します。');
    await _read(appFirebaseProvider).saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    AppLogger.d('$recordId の夕食を保存します。');
    await _read(appFirebaseProvider).saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の朝体温を保存します。');
    await _read(appFirebaseProvider).saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    AppLogger.d('$recordId の夜体温を保存します。');
    await _read(appFirebaseProvider).saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(RecordOverview overview) async {
    AppLogger.d('${overview.recordId} の体調情報を保存します。');
    await _read(appFirebaseProvider).saveOverview(overview);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    AppLogger.d('$recordId のお薬情報を保存します。');
    await _read(appFirebaseProvider).saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    AppLogger.d('$recordId のメモを保存します。');
    await _read(appFirebaseProvider).saveMemo(recordId, memo);
  }
}
