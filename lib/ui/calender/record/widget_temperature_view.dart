import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/ui/calender/record/widget_temperature_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:flutter/material.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView._(this.temperature, this.isMorning, this.onEditValue, this.dialogTitle);

  factory TemperatureView.morning({required double temperature, required Function(double?) onEditValue}) {
    return TemperatureView._(temperature, true, onEditValue, AppStrings.recordTemperatureMorning);
  }

  factory TemperatureView.night({required double temperature, required Function(double?) onEditValue}) {
    return TemperatureView._(temperature, false, onEditValue, AppStrings.recordTemperatureNight);
  }

  final String dialogTitle;
  final double temperature;
  final bool isMorning;
  final Function(double?) onEditValue;

  @override
  Widget build(BuildContext context) {
    final textColor = isMorning ? AppColors.morningTemperature : AppColors.nightTemperature;
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () async {
          final inputValue = await showDialog<double>(
            context: context,
            builder: (context) {
              return TemperatureEditDialog(
                title: dialogTitle,
                color: textColor,
                initValue: temperature,
              );
            },
          );
          onEditValue(inputValue);
        },
        child: Row(
          children: <Widget>[
            _verticalLine(),
            const SizedBox(width: 24.0),
            Column(
              children: <Widget>[
                _titleLabel(context),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _thermometerIcon(),
                    _temperatureLabel(context),
                  ],
                )
              ],
            ),
            const SizedBox(width: 24.0),
            _verticalLine(),
          ],
        ),
      ),
    );
  }

  Widget _verticalLine() {
    return Container(
      height: 80,
      width: 3,
      decoration: BoxDecoration(
        color: isMorning ? AppColors.morningTemperature : AppColors.nightTemperature,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }

  Widget _titleLabel(BuildContext context) {
    final title = isMorning ? AppStrings.recordTemperatureMorning : AppStrings.recordTemperatureNight;
    final textColor = isMorning ? AppColors.morningTemperature : AppColors.nightTemperature;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget _thermometerIcon() {
    return isMorning ? ThermometerIcon.morning() : ThermometerIcon.night();
  }

  Widget _temperatureLabel(BuildContext context) {
    final temperatureStr = (temperature > 0) ? '$temperature ${AppStrings.recordTemperatureUnit}' : AppStrings.recordTemperatureNonSet;
    Color fontColor;
    if ((temperature > 0)) {
      fontColor = isMorning ? AppColors.morningTemperature : AppColors.nightTemperature;
    } else {
      fontColor = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        temperatureStr,
        style: TextStyle(color: fontColor, fontSize: 20.0),
      ),
    );
  }
}
