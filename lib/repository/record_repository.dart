import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/remote/record_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recordRepositoryProvider = Provider((ref) => _RecordRepository(ref.read));

class _RecordRepository {
  const _RecordRepository(this._read);

  final Reader _read;

  Future<List<RecordOverview>> findEventRecords() async {
    final overviewRecords = await _read(recordApiProvider).findOverviewRecords();
    AppLogger.d('記録情報概要を全取得しました。登録数: ${overviewRecords.length}');
    return overviewRecords;
  }

  Future<RecordOverview?> findOverview(int id) async {
    return await _read(recordApiProvider).findOverviewRecord(id);
  }

  Future<Record> find(int id) async {
    return await _read(recordApiProvider).find(id);
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    await _read(recordApiProvider).saveBreakFast(recordId, breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    await _read(recordApiProvider).saveLunch(recordId, lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    await _read(recordApiProvider).saveDinner(recordId, dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    await _read(recordApiProvider).saveMorningTemperature(recordId, temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    await _read(recordApiProvider).saveNightTemperature(recordId, temperature);
  }

  Future<void> saveCondition(RecordOverview overview) async {
    await _read(recordApiProvider).saveCondition(overview);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    await _read(recordApiProvider).saveMedicineIds(recordId, idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    await _read(recordApiProvider).saveMemo(recordId, memo);
  }
}
