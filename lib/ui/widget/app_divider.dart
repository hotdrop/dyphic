import 'package:flutter/material.dart';

class DividerThemeColor extends StatelessWidget {
  const DividerThemeColor._(this.isSidePadding);

  factory DividerThemeColor.create() {
    return DividerThemeColor._(false);
  }

  factory DividerThemeColor.createWithPadding() {
    return DividerThemeColor._(true);
  }

  final bool isSidePadding;

  @override
  Widget build(BuildContext context) {
    if (isSidePadding) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Divider(color: Theme.of(context).accentColor),
      );
    } else {
      return Divider(color: Theme.of(context).accentColor);
    }
  }
}
