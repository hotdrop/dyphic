import 'package:dyphic/ui/notifier_view_model.dart';

class TemperatureViewModel extends NotifierViewModel {
  TemperatureViewModel._() {
    _init();
  }

  factory TemperatureViewModel.create() {
    return TemperatureViewModel._();
  }

  Future<void> _init() async {
    // TODO repositoryからデータ取得
    loadSuccess();
  }
}
