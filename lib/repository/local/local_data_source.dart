import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDataSourceProvider = Provider((ref) => const _LocalDataSource());

class _LocalDataSource {
  const _LocalDataSource();

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    // Hive使いたいのでここで初期化する
  }
}
