import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _MedicineViewModel(ref.read));

class _MedicineViewModel extends BaseViewModel {
  _MedicineViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    try {
      await _read(medicineProvider.notifier).refresh();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('お薬情報一覧の初回取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  // Future<void> reload() async {
  //   await _read(medicineProvider.notifier).onLoad();
  // }
}
