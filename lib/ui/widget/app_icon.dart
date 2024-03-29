import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppIcon extends StatelessWidget {
  const AppIcon._(this._iconData, this._iconColor, this.size);

  factory AppIcon.condition({double? size}) {
    return AppIcon._(Icons.sentiment_satisfied_rounded, AppColors.condition, size);
  }

  factory AppIcon.medicine({double? size}) {
    return AppIcon._(LineIcons.capsules, AppColors.medicine, size);
  }

  factory AppIcon.record({double? size}) {
    return AppIcon._(LineIcons.calendar, Colors.blueAccent, size);
  }

  factory AppIcon.note({double? size}) {
    return AppIcon._(LineIcons.edit, Colors.lime, size);
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
