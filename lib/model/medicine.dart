import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class Medicine {
  const Medicine({
    @required this.name,
    @required this.type,
    this.memo,
    this.imagePath = '',
    @required this.order,
  });

  factory Medicine.createEmpty(int order) {
    return Medicine(name: '', type: null, memo: '', imagePath: '', order: order);
  }

  final String name;
  final MedicineType type;
  final String memo;
  final String imagePath;
  final int order;

  Medicine copy({String imageUrl}) {
    return Medicine(name: name, type: type, order: order, memo: memo, imagePath: imageUrl);
  }

  String toTypeString() {
    switch (type) {
      case MedicineType.oral:
        return AppStrings.medicinePageOralName;
        break;
      case MedicineType.notOral:
        return AppStrings.medicinePageNotOralName;
        break;
      case MedicineType.intravenous:
        return AppStrings.medicinePageTypeIntravenousName;
        break;
      default:
        return '';
        break;
    }
  }

  @override
  String toString() {
    return '''
    name: $name
    type: ${toTypeString()}
    memo: $memo
    imagePath: $imagePath
    order: $order
    ''';
  }
}

enum MedicineType { oral, notOral, intravenous }
