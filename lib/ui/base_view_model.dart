import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_view_model.freezed.dart';

class BaseViewModel extends ChangeNotifier {
  UIState _uiState = const OnLoading();
  UIState get uiState => _uiState;

  void nowLoading() {
    _uiState = const OnLoading();
    notifyListeners();
  }

  void onSuccess() {
    _uiState = const OnSuccess();
    notifyListeners();
  }

  void onError(String message) {
    _uiState = OnLoading(errorMsg: message);
    notifyListeners();
  }
}

@freezed
class UIState with _$UIState {
  const factory UIState.loading({String? errorMsg}) = OnLoading;
  const factory UIState.success() = OnSuccess;
}
