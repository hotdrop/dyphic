import 'package:dyphic/service/mixin_app_auth.dart';
import 'package:dyphic/service/mixin_storage.dart';

class AppFirebase with AppAuthMixin, AppStorageMixin {
  AppFirebase._();

  ///
  /// このクラスを使用する場合はアプリ起動時に必ず1回initを呼ぶ
  ///
  factory AppFirebase.getInstance() {
    return _instance;
  }

  static final AppFirebase _instance = AppFirebase._();

  Future<void> init() async {
    await this.initAuth();
  }
}
