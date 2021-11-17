import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SplashViewModel(ref.read));

class _SplashViewModel extends BaseViewModel {
  _SplashViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    await _read(appSettingsProvider.notifier).init();
    onSuccess();
  }
}
