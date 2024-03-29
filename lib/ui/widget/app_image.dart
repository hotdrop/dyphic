import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage._(this._path, this._width, this._height);

  factory AppImage.icon({required String path}) {
    return AppImage._(path, 50.0, 50.0);
  }

  factory AppImage.large({required String path}) {
    return AppImage._(path, 150.0, 150.0);
  }

  final String _path;
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    if (_path.isEmpty) {
      return _loadImageDefault();
    } else if (_path.contains('http')) {
      return _loadImageFromNetwork();
    } else {
      return _loadImageFromLocalStorage();
    }
  }

  Widget _loadImageDefault() {
    return Image.asset(AppImages.noImage, height: _height, width: _width);
  }

  Widget _loadImageFromLocalStorage() {
    return Image.file(File(_path), height: _height, width: _width);
  }

  Widget _loadImageFromNetwork() {
    return CachedNetworkImage(
      imageUrl: _path,
      width: _width,
      height: _height,
      placeholder: (context, url) => SizedBox(
        width: _width,
        height: _height,
        child: const CircularProgressIndicator(),
      ),
      errorWidget: (context, url, dynamic error) => Image.asset(
        AppImages.noImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
