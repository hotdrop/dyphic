import 'dart:math';

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

  late List<Medicine> _medicines;
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
    if (_medicines.isNotEmpty) {
      return _medicines.map((e) => e.id).reduce(max) + 1;
    } else {
      return 1;
    }
  }

  int createNewOrder() {
    if (_medicines.isNotEmpty) {
      return _medicines.map((e) => e.order).reduce(max) + 1;
    } else {
      return 1;
    }
  }
}
