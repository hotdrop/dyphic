import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/local/dao/record_dao.dart';
import 'package:dyphic/repository/remote/record_api.dart';

final recordRepositoryProvider = Provider((ref) => _RecordRepository(ref.read));

class _RecordRepository {
  const _RecordRepository(this._read);

  final Reader _read;

  ///
  /// 記録情報をローカルから取得する。
  /// データがローカルにない場合はリモートから取得する。
  /// isForceUpdate がtrueの場合はリモートのデータで最新化する。
  ///
  Future<List<Record>> findAll(bool isForceUpdate) async {
    final records = await _read(recordDaoProvider).findAll();
    if (records.isNotEmpty && !isForceUpdate) {
      records.sort((a, b) => a.id - b.id);
      return records;
    }
    // 0件ならリモートから取得
    final newRecords = await _read(recordApiProvider).findAll();
    newRecords.sort((a, b) => a.id - b.id);
    await _read(recordDaoProvider).saveAll(newRecords);
    return newRecords;
  }

  ///
  /// リモートから指定した記録情報を更新する
  ///
  Future<void> refresh(int id) async {
    final record = await _read(recordApiProvider).find(id);
    if (record != null) {
      await _read(recordDaoProvider).save(record);
    }
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    await _read(recordApiProvider).saveBreakFast(recordId, breakFast);
    await _read(recordDaoProvider).saveItem(recordId, breakfast: breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    await _read(recordApiProvider).saveLunch(recordId, lunch);
    await _read(recordDaoProvider).saveItem(recordId, lunch: lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    await _read(recordApiProvider).saveDinner(recordId, dinner);
    await _read(recordDaoProvider).saveItem(recordId, dinner: dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    await _read(recordApiProvider).saveMorningTemperature(recordId, temperature);
    await _read(recordDaoProvider).saveItem(recordId, morningTemperature: temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    await _read(recordApiProvider).saveNightTemperature(recordId, temperature);
    await _read(recordDaoProvider).saveItem(recordId, nightTemperature: temperature);
  }

  Future<void> saveCondition(Record record) async {
    await _read(recordApiProvider).saveCondition(record);
    await _read(recordDaoProvider).saveCondition(record);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    await _read(recordApiProvider).saveMedicineIds(recordId, idsStr);
    await _read(recordDaoProvider).saveItem(recordId, medicineIdsStr: idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    await _read(recordApiProvider).saveMemo(recordId, memo);
    await _read(recordDaoProvider).saveItem(recordId, memo: memo);
  }
}
