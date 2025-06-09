import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:dyphic/repository/local/entity/condition_entity.dart';
import 'package:dyphic/repository/local/entity/medicine_entity.dart';
import 'package:dyphic/repository/local/entity/note_entity.dart';
import 'package:dyphic/repository/local/entity/record_entity.dart';

final localDataSourceProvider = Provider((ref) => const LocalDataSource());

///
/// テストで使うためprivateスコープにはしない
///
class LocalDataSource {
  const LocalDataSource();

  static Isar? _instance;

  Isar get isar {
    if (_instance != null) {
      return _instance!;
    } else {
      throw StateError('Isarを初期化せずに使用しようとしました');
    }
  }

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    if (_instance != null && _instance!.isOpen) {
      return;
    }

    final dirPath = await getDirectoryPath();
    // デバッグ用とリリース用でIsarのデータファイル名を分ける
    const isarName = kReleaseMode ? 'release_db' : Isar.defaultName;

    _instance = await Isar.open(
      [
        RecordEntitySchema,
        ConditionEntitySchema,
        MedicineEntitySchema,
        NoteEntitySchema,
      ],
      directory: dirPath,
      name: isarName,
    );
  }

  ///
  /// テストでoverrideしてテンポラリディレクトリを使うためpublicスコープで定義する
  ///
  Future<String> getDirectoryPath() async {
    final dir = await path.getApplicationDocumentsDirectory();
    return dir.path;
  }
}
