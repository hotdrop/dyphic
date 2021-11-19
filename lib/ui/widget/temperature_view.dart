import 'package:dyphic/model/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/temperature_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemperatureView extends ConsumerWidget {
  const TemperatureView._(
    this.temperature,
    this.color,
    this.title,
    this.thermometerIcon,
    this.onSubmitted,
    this.dialogTitle,
  );

  factory TemperatureView.morning({
    required double temperature,
    required Function(double?) onSubmitted,
  }) {
    return TemperatureView._(
      temperature,
      AppColors.morningTemperature,
      AppStrings.recordTemperatureMorning,
      ThermometerIcon.morning(),
      onSubmitted,
      AppStrings.recordTemperatureMorning,
    );
  }

  factory TemperatureView.night({
    required double temperature,
    required Function(double?) onSubmitted,
  }) {
    return TemperatureView._(
      temperature,
      AppColors.nightTemperature,
      AppStrings.recordTemperatureNight,
      ThermometerIcon.night(),
      onSubmitted,
      AppStrings.recordTemperatureNight,
    );
  }

  final String dialogTitle;
  final Color color;
  final String title;
  final ThermometerIcon thermometerIcon;
  final double temperature;
  final Function(double?) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.read(appSettingsProvider).isSignIn;
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: isSignIn ? () async => await _showEditDialog(context) : null,
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

  Future<void> _showEditDialog(BuildContext context) async {
    final inputValue = await TemperatureEditDialog.show(
      context,
      dialogTitle: dialogTitle,
      color: color,
      initValue: temperature,
    );
    onSubmitted(inputValue);
  }

  Widget _viewTitle(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: color),
    );
  }

  Widget _viewTemperatureLabel(BuildContext context) {
    final temperatureStr = (temperature > 0) ? '$temperature ${AppStrings.recordTemperatureUnit}' : AppStrings.recordTemperatureNonSet;
    final fontColor = (temperature > 0) ? color : Colors.grey;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
