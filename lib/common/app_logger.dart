import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static Future<void> e(String message, dynamic exception, StackTrace stackTrace) async {
    if (kDebugMode) {
      _logger.e(message, exception);
    } else {
      await FirebaseCrashlytics.instance.setCustomKey('message', message);
      await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    }
  }
}
