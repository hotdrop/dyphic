import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText._(this.text, this.size, this.maxLines);

  factory AppText.normal({@required String text}) {
    return AppText._(text, 12.0, 1);
  }

  factory AppText.multiLine({@required String text, @required int maxLines}) {
    return AppText._(text, 12.0, maxLines);
  }

  final String text;
  final double size;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (maxLines == 1) {
      return _singleLineText();
    } else {
      return _multiLineText();
    }
  }

  Widget _singleLineText() {
    return Text(
      text,
      style: TextStyle(fontSize: size),
    );
  }

  Widget _multiLineText() {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: size),
    );
  }
}
