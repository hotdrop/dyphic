import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppCrashlytics {
  AppCrashlytics._();

  factory AppCrashlytics.getInstance() {
    return _instance;
  }

  static final AppCrashlytics _instance = AppCrashlytics._();

  Future<void> record(String message, dynamic exception, StackTrace stackTrace) async {
    await FirebaseCrashlytics.instance.setCustomKey("message", message);
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }
}
