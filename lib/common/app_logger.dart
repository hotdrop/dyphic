import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static Future<void> e(String message, dynamic exception, StackTrace stackTrace) async {
    // if (kDebugMode) {
    _logger.e(message, exception);
    // } else {
    //   await RSCrashlytics.getInstance().record(message, exception, stackTrace);
    // }
  }
}
