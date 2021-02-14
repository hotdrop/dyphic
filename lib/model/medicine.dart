import 'package:flutter/material.dart';

class Medicine {
  const Medicine({
    @required this.name,
    @required this.isOral,
    @required this.detail,
  });

  final String name;
  final bool isOral;
  final String detail;
}
