import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppTemperature extends StatelessWidget {
  const AppTemperature._(this.temperature, this.isMorning, this.onTap);

  factory AppTemperature.morning({@required double temperature, @required Function onTap}) {
    final t = temperature != null ? temperature : 0.0;
    return AppTemperature._(t, true, onTap);
  }

  factory AppTemperature.night({@required double temperature, @required Function onTap}) {
    final t = temperature != null ? temperature : 0.0;
    return AppTemperature._(t, false, onTap);
  }

  final double temperature;
  final bool isMorning;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          _verticalLine(),
          SizedBox(width: 6),
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
          SizedBox(width: 12),
          _verticalLine(),
        ],
      ),
      onTap: () => onTap(),
    );
  }

  Widget _verticalLine() {
    return Container(
      height: 60,
      width: 2,
      decoration: BoxDecoration(
        color: isMorning ? AppColors.morningTemperature : AppColors.nightTemperature,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }

  Widget _titleLabel(BuildContext context) {
    final title = isMorning ? AppStrings.recordTemperatureMorning : AppStrings.recordTemperatureNight;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _thermometerIcon() {
    final pngPath = isMorning ? 'res/images/ic_thermometer_morning.png' : 'res/images/ic_thermometer_night.png';
    return SizedBox(
      width: 28,
      height: 28,
      child: Image.asset(pngPath),
    );
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
