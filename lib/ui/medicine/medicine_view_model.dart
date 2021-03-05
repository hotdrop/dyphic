import 'dart:math';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class MedicineViewModel extends NotifierViewModel {
  MedicineViewModel._(this._repository, this._accountRepository) {
    _init();
  }

  factory MedicineViewModel.create() {
    return MedicineViewModel._(MedicineRepository.create(), AccountRepository.create());
  }

  final MedicineRepository _repository;
  final AccountRepository _accountRepository;

  List<Medicine> _medicines;
  List<Medicine> get medicines => _medicines;

  bool _isLogin;
  bool get isLogin => _isLogin;

  Future<void> _init() async {
    _medicines = await _repository.findAll();
    _isLogin = _accountRepository.isLogIn;
    loadSuccess();
  }

  Future<void> reload() async {
    nowLoading();
    _medicines = await _repository.findAll();
    loadSuccess();
  }

  int getLastOrder() {
    int lastOrder;
    if (_medicines.isNotEmpty) {
      lastOrder = _medicines.map((e) => e.order).reduce(max);
    } else {
      lastOrder = 0;
    }
    AppLogger.d('お薬の並び順のラストオーダー: $lastOrder');
    return lastOrder + 1;
  }
}
