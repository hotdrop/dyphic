import 'package:dyphic/service/mixin_app_auth.dart';
import 'package:dyphic/service/mixin_crashlytics.dart';
import 'package:dyphic/service/mixin_firestore.dart';
import 'package:dyphic/service/mixin_storage.dart';

///
/// このクラスを使用する場合はアプリ起動時に必ず1回initを呼ぶ
///
class AppFirebase with AppAuthMixin, AppStorageMixin, AppFirestoreMixin, AppCrashlytics {
  AppFirebase._();

  static final AppFirebase _instance = AppFirebase._();
  static AppFirebase get instance => _instance;

  Future<void> init() async {
    await initAuth();
    await initCrashlytics();
  }
}
