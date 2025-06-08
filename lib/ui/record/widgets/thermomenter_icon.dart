import 'package:dyphic/res/app_images.dart';
import 'package:flutter/material.dart';

class ThermometerIcon extends StatelessWidget {
  const ThermometerIcon._(this.imagePath);

  factory ThermometerIcon.morning() {
    return const ThermometerIcon._(AppImages.icThermometerMorning);
  }

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Image.asset(imagePath),
    );
  }
}
