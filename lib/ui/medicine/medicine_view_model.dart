import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/medicine.dart';
import 'package:dalico/model/page_state.dart';
import 'package:dalico/repository/medicine_repository.dart';
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

  void _nowLoading() {
    pageState = PageNowLoading();
    notifyListeners();
  }

  void _loadSuccess() {
    pageState = PageLoaded();
    notifyListeners();
  }
}
