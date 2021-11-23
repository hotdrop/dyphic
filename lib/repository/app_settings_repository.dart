import 'package:dyphic/repository/local/shared_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingRepository(ref.read));

class _AppSettingRepository {
  _AppSettingRepository(this._read);

  final Reader _read;

  Future<bool> isDarkMode() async {
    return await _read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> changeDarkMode() async {
    await _read(sharedPrefsProvider).saveDarkMode(true);
  }

  Future<void> changeLightMode() async {
    await _read(sharedPrefsProvider).saveDarkMode(false);
  }
}
