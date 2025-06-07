extension AppCollection<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) f) {
    for (final e in this) {
      if (f(e)) return e;
    }
    return null;
  }
}
