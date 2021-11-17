import 'package:flutter/material.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/temperature_dialog.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView._(
    this.temperature,
    this.color,
    this.title,
    this.thermometerIcon,
    this.isEditable,
    this.onEditValue,
    this.dialogTitle,
  );

  factory TemperatureView.morning({
    required double temperature,
    required bool isEditable,
    required Function(double?) onEditValue,
  }) {
    return TemperatureView._(
      temperature,
      AppColors.morningTemperature,
      AppStrings.recordTemperatureMorning,
      ThermometerIcon.morning(),
      isEditable,
      onEditValue,
      AppStrings.recordTemperatureMorning,
    );
  }

  factory TemperatureView.night({
    required double temperature,
    required bool isEditable,
    required Function(double?) onEditValue,
  }) {
    return TemperatureView._(
      temperature,
      AppColors.nightTemperature,
      AppStrings.recordTemperatureNight,
      ThermometerIcon.night(),
      isEditable,
      onEditValue,
      AppStrings.recordTemperatureNight,
    );
  }

  final String dialogTitle;
  final double temperature;
  final Color color;
  final String title;
  final ThermometerIcon thermometerIcon;
  final bool isEditable;
  final Function(double?) onEditValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: (isEditable)
            ? () async {
                final inputValue = await TemperatureEditDialog.show(context, dialogTitle: dialogTitle, color: color, initValue: temperature);
                onEditValue(inputValue);
              }
            : null,
        child: Row(
          children: <Widget>[
            _VerticalLine(color),
            const SizedBox(width: 24.0),
            Column(
              children: <Widget>[
                _viewTitle(context),
                const SizedBox(height: 4),
                _viewTemperatureLabel(context),
              ],
            ),
            const SizedBox(width: 24.0),
            _VerticalLine(color),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: color),
    );
  }

  Widget _viewTemperatureLabel(BuildContext context) {
    final temperatureStr = (temperature > 0) ? '$temperature ${AppStrings.recordTemperatureUnit}' : AppStrings.recordTemperatureNonSet;
    Color fontColor = (temperature > 0) ? color : Colors.grey;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        thermometerIcon,
        const SizedBox(width: 4),
        Text(temperatureStr, style: TextStyle(color: fontColor, fontSize: 24)),
      ],
    );
  }
}

class _VerticalLine extends StatelessWidget {
  const _VerticalLine(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}
