import 'package:dyphic/service/mixin_app_auth.dart';
import 'package:dyphic/service/mixin_crashlytics.dart';
import 'package:dyphic/service/mixin_firestore.dart';
import 'package:dyphic/service/mixin_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appFirebaseProvider = Provider((ref) => _AppFirebase());

class _AppFirebase with AppAuthMixin, AppStorageMixin, AppFirestoreMixin, AppCrashlytics {
  _AppFirebase();

  Future<void> init() async {
    await Firebase.initializeApp();
    await initCrashlytics();
  }
}
