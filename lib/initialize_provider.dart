import 'package:dyphic/repository/condition_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  await ref.read(localDataSourceProvider).init();

  // お薬情報の初期化
  final isLoadedMedicineData = await ref.read(medicineRepositoryProvider).isLoaded();
  if (!isLoadedMedicineData) {
    await ref.read(medicineRepositoryProvider).onLoadLatest();
  }

  // 体調情報の初期化
  final isLoadedConditionData = await ref.read(conditionRepositoryProvider).isLoaded();
  if (!isLoadedConditionData) {
    await ref.read(conditionRepositoryProvider).onLoadLatest();
  }
});
