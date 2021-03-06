import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({@required this.path});

  final String path;
  static final double _width = 200.0;
  static final double _height = 200.0;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return _loadImageDefault();
    } else if (path.contains('http')) {
      return _loadImageFromNetwork();
    } else {
      return _loadImageFromLocalStorage();
    }
  }

  Widget _loadImageDefault() {
    return Image.asset('res/images/medicine_default.png', height: _height, width: _width);
  }

  Widget _loadImageFromLocalStorage() {
    return Image.file(File(path), height: _height, width: _width);
  }

  Widget _loadImageFromNetwork() {
    return CachedNetworkImage(
      imageUrl: path,
      placeholder: (context, url) => SizedBox(
        width: _width,
        height: _height,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, dynamic error) => Image.asset(
        'res/images/medicine_default.png',
        width: _width,
        height: _height,
      ),
    );
  }
}
