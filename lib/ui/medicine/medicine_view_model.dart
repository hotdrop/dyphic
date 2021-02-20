import 'dart:math';

import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:flutter/material.dart';

class MedicineViewModel extends ChangeNotifier {
  MedicineViewModel._(this._repository);

  factory MedicineViewModel.create() {
    return MedicineViewModel._(MedicineRepository.create());
  }

  final MedicineRepository _repository;
  List<Medicine> _medicines;
  List<Medicine> get medicines => _medicines;
  PageState pageState = PageNowLoading();

  Future<void> init() async {
    _nowLoading();
    _medicines = await _repository.findAll();
    _loadSuccess();
  }

  Future<void> reload() async {
    _nowLoading();
    _medicines = await _repository.findAll();
    _loadSuccess();
  }

  int getLastOrder() {
    // sortされている前提
    final lastOrder = _medicines.last.order;
    return lastOrder + 1;
  }

  void _nowLoading() {
    pageState = PageNowLoading();
    notifyListeners();
  }

  void _loadSuccess() {
    pageState = PageLoaded();
    notifyListeners();
  }
}
