import 'dart:math';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class MedicineViewModel extends NotifierViewModel {
  MedicineViewModel._(this._repository) {
    _init();
  }

  factory MedicineViewModel.create() {
    return MedicineViewModel._(MedicineRepository.create());
  }

  final MedicineRepository _repository;

  List<Medicine> _medicines;
  List<Medicine> get medicines => _medicines;

  Future<void> _init() async {
    _medicines = await _repository.findAll();
    loadSuccess();
  }

  Future<void> reload() async {
    nowLoading();
    _medicines = await _repository.findAll();
    loadSuccess();
  }

  int createNewId() {
    int newId;
    if (_medicines.isNotEmpty) {
      final lastId = _medicines.map((e) => e.id).reduce(max);
      newId = lastId + 1;
    } else {
      newId = 1;
    }
    AppLogger.d('お薬の新規ID作成: $newId');
    return newId;
  }

  int createNewOrder() {
    int newOrder;
    if (_medicines.isNotEmpty) {
      final lastOrder = _medicines.map((e) => e.order).reduce(max);
      newOrder = lastOrder + 1;
    } else {
      newOrder = 1;
    }
    AppLogger.d('お薬の並び順のラストオーダー: $newOrder');
    return newOrder;
  }
}
