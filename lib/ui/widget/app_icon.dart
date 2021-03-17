import 'package:dyphic/common/app_colors.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon._(this._iconData, this._iconColor, this.size);

  factory AppIcon.condition(bool isDarkMode, {double? size}) {
    Color c = (isDarkMode) ? AppColors.conditionNight : AppColors.condition;
    return AppIcon._(Icons.sentiment_satisfied_rounded, c, size);
  }

  factory AppIcon.medicine(bool isDarkMode, {double? size}) {
    Color c = (isDarkMode) ? AppColors.medicineNight : AppColors.medicine;
    return AppIcon._(Icons.medical_services, c, size);
  }

  factory AppIcon.changeTheme(bool isDarkMode, {double? size}) {
    final icon = (isDarkMode) ? Icons.brightness_7 : Icons.brightness_4;
    Color c = (isDarkMode) ? Colors.blue[900]! : Colors.pink[200]!;
    return AppIcon._(icon, c, size);
  }

  final IconData _iconData;
  final Color _iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return Icon(
        _iconData,
        color: _iconColor,
        size: size,
      );
    } else {
      return Icon(_iconData, color: _iconColor);
    }
  }
}

class ThermometerIcon extends StatelessWidget {
  const ThermometerIcon._(this.imagePath);

  factory ThermometerIcon.morning() {
    return ThermometerIcon._('res/images/ic_thermometer_morning.png');
  }

  factory ThermometerIcon.night() {
    return ThermometerIcon._('res/images/ic_thermometer_night.png');
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
