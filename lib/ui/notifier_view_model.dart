import 'package:flutter/material.dart';
import 'package:dyphic/model/page_state.dart';

class NotifierViewModel extends ChangeNotifier {
  PageLoadingState _pageState = PageLoadingState.nowLoading();
  PageLoadingState get pageState => _pageState;

  void nowLoading() {
    _pageState = PageLoadingState.nowLoading();
    notifyListeners();
  }

  void loadSuccess() {
    _pageState = PageLoadingState.loadSuccess();
    notifyListeners();
  }

  void loadError() {
    _pageState = PageLoadingState.loadError();
    notifyListeners();
  }
}
