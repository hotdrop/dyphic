import 'package:flutter/material.dart';

class Medicine {
  const Medicine({
    @required this.name,
    @required this.isOral,
    this.memo,
    this.imagePath = '',
    @required this.order,
  });

  factory Medicine.createEmpty(int order) {
    return Medicine(name: '', isOral: true, memo: '', imagePath: '', order: order);
  }

  final String name;
  final bool isOral;
  final String memo;
  final String imagePath;
  final int order;
}
