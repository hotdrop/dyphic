import 'package:dyphic/service/mixin_app_auth.dart';
import 'package:dyphic/service/mixin_storage.dart';

class AppFirebase with AppAuthMixin, AppStorageMixin {
  AppFirebase._();

  factory AppFirebase.getInstance() {
    return _instance;
  }

  static final AppFirebase _instance = AppFirebase._();

  Future<void> load() async {
    await this.initAuth();
  }
}
