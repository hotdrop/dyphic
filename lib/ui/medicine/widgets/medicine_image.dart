import 'dart:io';

import 'package:dyphic/res/app_images.dart';
import 'package:flutter/material.dart';

class MedicineImage extends StatelessWidget {
  const MedicineImage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final path = '${AppImages.medicineImagePath}/$id.jpg';
    return Image.file(File(path), height: 50, width: 50);
  }
}
