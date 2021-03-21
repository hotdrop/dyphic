// こういうのそのうちStringクラスにデフォルトで入ると思うがそれまで拡張関数を使う
extension StringExtension on String? {
  bool isNullOrEmpty() {
    return this?.isEmpty ?? true;
  }

  bool haveValue() {
    return this?.isNotEmpty ?? false;
  }
}

extension IntExtension on int? {
  bool haveValue() {
    final a = this;
    return (a != null) ? a > 0 : false;
  }
}
