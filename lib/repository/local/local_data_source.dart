import 'package:dyphic/repository/local/entity/condition_entity.dart';
import 'package:dyphic/repository/local/entity/event_entity.dart';
import 'package:dyphic/repository/local/entity/medicine_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final localDataSourceProvider = Provider((ref) => const _LocalDataSource());

class _LocalDataSource {
  const _LocalDataSource();

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ConditionEntityAdapter());
    Hive.registerAdapter(EventEntityAdapter());
    Hive.registerAdapter(MedicineEntityAdapter());
  }
}
