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
