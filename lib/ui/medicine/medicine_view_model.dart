import 'dart:math';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _MedicineViewModel(ref.read));

class _MedicineViewModel extends BaseViewModel {
  _MedicineViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late List<Medicine> _medicines;
  List<Medicine> get medicines => _medicines;

  bool get isSignIn => _read(accountRepositoryProvider).isSignIn;

  Future<void> _init() async {
    try {
      _medicines = await _read(medicineRepositoryProvider).findAll();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('お薬情報一覧の初回取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> reload() async {
    try {
      _medicines = await _read(medicineRepositoryProvider).findAll();
      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('お薬情報一覧の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  int createNewId() {
    return (_medicines.isNotEmpty) ? _medicines.map((e) => e.id).reduce(max) + 1 : 1;
  }

  int createNewOrder() {
    return (_medicines.isNotEmpty) ? _medicines.map((e) => e.order).reduce(max) + 1 : 1;
  }
}
