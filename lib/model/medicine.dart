import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class Medicine {
  const Medicine({
    @required this.id,
    @required this.name,
    @required this.overview,
    @required this.type,
    this.memo,
    this.imagePath = '',
    @required this.order,
  });

  factory Medicine.createEmpty(int id, int order) {
    return Medicine(id: id, name: '', overview: '', type: MedicineType.oral, memo: '', imagePath: '', order: order);
  }

  final int id;
  final String name;
  final String overview;
  final MedicineType type;
  final String memo;
  final String imagePath;
  final int order;

  Medicine copy({String imageUrl}) {
    return Medicine(id: id, name: name, overview: overview, type: type, order: order, memo: memo, imagePath: imageUrl);
  }

  String toTypeString() {
    switch (type) {
      case MedicineType.oral:
        return AppStrings.medicinePageOralName;
      case MedicineType.notOral:
        return AppStrings.medicinePageNotOralName;
      case MedicineType.intravenous:
        return AppStrings.medicinePageTypeIntravenousName;
      default:
        return '';
    }
  }

  @override
  String toString() {
    return '''
    id: $id
    name: $name
    overview: $overview
    type: ${toTypeString()}
    memo: $memo
    imagePath: $imagePath
    order: $order
    ''';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'overview': overview,
      'type': type.index,
      'imagePath': imagePath,
      'memo': memo,
      'order': order,
    };
  }

  static MedicineType toType(int index) {
    if (index == MedicineType.oral.index) {
      return MedicineType.oral;
    } else if (index == MedicineType.notOral.index) {
      return MedicineType.notOral;
    } else {
      return MedicineType.intravenous;
    }
  }
}

enum MedicineType { oral, notOral, intravenous }
