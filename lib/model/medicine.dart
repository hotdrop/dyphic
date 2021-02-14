import 'package:flutter/material.dart';

class Medicine {
  const Medicine({
    @required this.name,
    @required this.isOral,
    @required this.memo,
    this.imagePath = '',
  });

  final String name;
  final bool isOral;
  final String memo;
  final String imagePath;
}
