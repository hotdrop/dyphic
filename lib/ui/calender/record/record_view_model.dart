import 'package:dalico/model/page_state.dart';
import 'package:dalico/model/record.dart';
import 'package:dalico/repository/record_repository.dart';
import 'package:flutter/material.dart';

class RecordViewModel extends ChangeNotifier {
  RecordViewModel._(this.id, this._repository);

  factory RecordViewModel.create(int id) {
    return RecordViewModel._(id, RecordRepository.create());
  }

  final int id;
  final RecordRepository _repository;
  PageState pageState = PageNowLoading();

  Record _record;
  Record get record => _record;

  Future<void> init() async {
    _nowLoading();
    _record = await _repository.find(id);
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
