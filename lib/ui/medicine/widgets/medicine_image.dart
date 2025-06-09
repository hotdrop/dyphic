import 'package:dyphic/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MedicineImage extends StatelessWidget {
  const MedicineImage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final path = '${AppImages.medicineImagePath}/$id.jpg';
    return FutureBuilder(
      future: existsImageFile(path),
      builder: (context, snapshot) {
        final exists = snapshot.data ?? false;
        final displayPath = (exists) ? path : AppImages.noImage;
        return Image.asset(displayPath, height: 50, width: 50);
      },
    );
  }

  Future<bool> existsImageFile(String assetpath) async {
    try {
      await rootBundle.load(assetpath);
      return true;
    } catch (_) {
      return false;
    }
  }
}
