import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:flutter/material.dart';

///
/// レコード詳細ページの各エリアのタイトル
///
class ContentsTitle extends StatelessWidget {
  const ContentsTitle({
    Key? key,
    required this.title,
    required this.appIcon,
  }) : super(key: key);

  final String title;
  final AppIcon appIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        appIcon,
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
