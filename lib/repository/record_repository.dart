import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/local/dao/record_dao.dart';
import 'package:dyphic/repository/remote/record_api.dart';

final recordRepositoryProvider = Provider((ref) => _RecordRepository(ref));

class _RecordRepository {
  const _RecordRepository(this._ref);

  final Ref _ref;

  ///
  /// 指定したIDの記録情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<Record> find(int id) async {
    return await _ref.read(recordDaoProvider).find(id);
  }

  ///
  /// 全記録情報をローカルから取得する
  /// 取得先: ローカルストレージ
  ///
  Future<List<Record>> findAll() async {
    final records = await _ref.read(recordDaoProvider).findAll();
    if (records.isEmpty) {
      return [];
    }

    records.sort((a, b) => a.id - b.id);
    return records;
  }

  ///
  /// 記録情報を最新のものに更新する
  /// 取得先: サーバー
  ///
  Future<void> onLoadLatest() async {
    final newRecords = await _ref.read(recordApiProvider).findAll();
    newRecords.sort((a, b) => a.id - b.id);
    await _ref.read(recordDaoProvider).saveAll(newRecords);
  }

  ///
  /// 指定IDの記録情報を更新する
  /// 取得先: サーバー
  ///
  Future<void> refresh(int id) async {
    final record = await _ref.read(recordApiProvider).find(id);
    if (record != null) {
      await _ref.read(recordDaoProvider).save(record);
    }
  }

  Future<void> saveBreakFast(int recordId, String breakFast) async {
    await _ref.read(recordApiProvider).saveBreakFast(recordId, breakFast);
    await _ref.read(recordDaoProvider).saveItem(recordId, breakfast: breakFast);
  }

  Future<void> saveLunch(int recordId, String lunch) async {
    await _ref.read(recordApiProvider).saveLunch(recordId, lunch);
    await _ref.read(recordDaoProvider).saveItem(recordId, lunch: lunch);
  }

  Future<void> saveDinner(int recordId, String dinner) async {
    await _ref.read(recordApiProvider).saveDinner(recordId, dinner);
    await _ref.read(recordDaoProvider).saveItem(recordId, dinner: dinner);
  }

  Future<void> saveMorningTemperature(int recordId, double temperature) async {
    await _ref.read(recordApiProvider).saveMorningTemperature(recordId, temperature);
    await _ref.read(recordDaoProvider).saveItem(recordId, morningTemperature: temperature);
  }

  Future<void> saveNightTemperature(int recordId, double temperature) async {
    await _ref.read(recordApiProvider).saveNightTemperature(recordId, temperature);
    await _ref.read(recordDaoProvider).saveItem(recordId, nightTemperature: temperature);
  }

  Future<void> saveCondition(Record record) async {
    await _ref.read(recordApiProvider).saveCondition(record);
    await _ref.read(recordDaoProvider).saveCondition(record);
  }

  Future<void> saveMedicineIds(int recordId, String idsStr) async {
    await _ref.read(recordApiProvider).saveMedicineIds(recordId, idsStr);
    await _ref.read(recordDaoProvider).saveItem(recordId, medicineIdsStr: idsStr);
  }

  Future<void> saveMemo(int recordId, String memo) async {
    await _ref.read(recordApiProvider).saveMemo(recordId, memo);
    await _ref.read(recordDaoProvider).saveItem(recordId, memo: memo);
  }
}
