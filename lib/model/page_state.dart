class PageLoadingState {
  PageLoadingState._(this._state);

  factory PageLoadingState.nowLoading() {
    return PageLoadingState._(_PageLoadingStateEnum.nowLoading);
  }

  factory PageLoadingState.loadSuccess() {
    return PageLoadingState._(_PageLoadingStateEnum.success);
  }

  factory PageLoadingState.loadError() {
    return PageLoadingState._(_PageLoadingStateEnum.error);
  }

  final _PageLoadingStateEnum _state;

  bool get isLoadSuccess => _state == _PageLoadingStateEnum.success;
}

enum _PageLoadingStateEnum { nowLoading, success, error }

abstract class PageState {
  bool nowLoading();
  bool loadSuccess();
  bool loadError();
}

class PageNowLoading extends PageState {
  @override
  bool nowLoading() => true;
  @override
  bool loadSuccess() => false;
  @override
  bool loadError() => false;
}

class PageLoaded extends PageState {
  @override
  bool nowLoading() => false;
  @override
  bool loadSuccess() => true;
  @override
  bool loadError() => false;
}

class PageLoadError extends PageState {
  @override
  bool nowLoading() => false;
  @override
  bool loadSuccess() => false;
  @override
  bool loadError() => true;
}
