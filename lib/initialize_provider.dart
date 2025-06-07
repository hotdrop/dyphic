import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dyphic/model/condition.dart';
import 'package:dyphic/service/firebase_crashlytics.dart';
import 'package:dyphic/firebase_options.dart';
import 'package:dyphic/repository/local/local_data_source.dart';

///
/// アプリの初期化処理はここで行う
///
final initializerProvider = FutureProvider((ref) async {
  // Firebaseの初期化処理
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ref.read(firebaseCrashlyticsProvider).init();

  // TODO ローカルDBの初期化。これ不要
  await ref.read(localDataSourceProvider).init();

  // 体調情報の初期化
  if (ref.read(conditionsProvider).isEmpty) {
    await ref.read(conditionsProvider.notifier).onLoad();
  }
});
