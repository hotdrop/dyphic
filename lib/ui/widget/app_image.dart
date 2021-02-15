import 'dart:io';

import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({@required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.isNotEmpty) {
      return Image.file(File(path), height: 200.0, width: 200.0);
    } else {
      return Image.asset('res/images/medicine_default.png', height: 200.0, width: 200.0);
    }
  }
}
