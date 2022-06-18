import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MorningTemperatureWidget extends StatelessWidget {
  const MorningTemperatureWidget({Key? key, required this.currentValue, required this.onSubmitted}) : super(key: key);

  final double? currentValue;
  final Function(double) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TemperatureView(
      temperature: currentValue ?? 0,
      color: AppColors.morningTemperature,
      title: AppStrings.recordTemperatureMorning,
      thermometerIcon: ThermometerIcon.morning(),
      dialogTitle: AppStrings.recordTemperatureMorning,
      onSubmitted: onSubmitted,
    );
  }
}

class TemperatureView extends ConsumerWidget {
  const TemperatureView({
    Key? key,
    required this.temperature,
    required this.color,
    required this.title,
    required this.thermometerIcon,
    required this.onSubmitted,
    required this.dialogTitle,
  }) : super(key: key);

  final String dialogTitle;
  final Color color;
  final String title;
  final ThermometerIcon thermometerIcon;
  final double temperature;
  final Function(double) onSubmitted;

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
    final inputValue = await _TemperatureEditDialog.show(
          context,
          dialogTitle: dialogTitle,
          color: color,
          initValue: temperature,
        ) ??
        0.0;
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

class _TemperatureEditDialog extends StatefulWidget {
  const _TemperatureEditDialog._(this.title, this.color, this.initValue);

  final String title;
  final Color color;
  final double? initValue;

  @override
  State<_TemperatureEditDialog> createState() => _TemperatureEditDialogState();

  static Future<double?> show(
    BuildContext context, {
    required String dialogTitle,
    required Color color,
    double? initValue,
  }) async {
    return await showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _TemperatureEditDialog._(dialogTitle, color, initValue);
      },
    );
  }
}

class _TemperatureEditDialogState extends State<_TemperatureEditDialog> {
  final _controller = TextEditingController();
  List<String> inputValues = [];

  @override
  void initState() {
    super.initState();

    double? i = widget.initValue ?? 0;
    if (i > 0) {
      final initVal = i.toString();
      inputValues = initVal.split('');
      _controller.text = '$initVal ℃';
    } else {
      _controller.text = '**.** ℃';
    }
  }

  void input(int i) {
    setState(() {
      if (inputValues.isEmpty) {
        _controller.text = '$i*.** ℃';
        inputValues.add(i.toString());
      } else if (inputValues.length == 1) {
        _controller.text = '${inputValues.join()}$i.** ℃';
        inputValues.add(i.toString());
      } else if (inputValues.length >= 2 && inputValues.length <= 3) {
        _controller.text = '${inputValues.join()}.$i* ℃';
        inputValues.add('.');
        inputValues.add(i.toString());
      } else if (inputValues.length == 4) {
        _controller.text = '${inputValues.join()}$i ℃';
        inputValues.add(i.toString());
      } else {
        // これ以外は無視
      }
    });
  }

  void delete() {
    setState(() {
      if (inputValues.length == 1) {
        _controller.text = '**.** ℃';
        inputValues.removeLast();
      } else if (inputValues.length == 2) {
        inputValues.removeLast();
        _controller.text = '${inputValues.join()}*.** ℃';
      } else if (inputValues.length == 4) {
        inputValues.removeLast();
        inputValues.removeLast();
        _controller.text = '${inputValues.join()}.** ℃';
      } else if (inputValues.length == 5) {
        inputValues.removeLast();
        _controller.text = '${inputValues.join()}* ℃';
      } else {
        // これ以外は無視
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: TextStyle(color: widget.color)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              _controller.text,
              style: TextStyle(fontSize: 32.0, color: widget.color),
            ),
          ),
          const SizedBox(height: 16.0),
          _keyboard(context),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: () {
            String v = inputValues.join();
            Navigator.pop<double>(context, double.parse(v));
          },
          child: const Text(AppStrings.dialogOk),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _keyboard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _NumberCircleButton(number: 1, onTap: () => input(1)),
            _NumberCircleButton(number: 4, onTap: () => input(4)),
            _NumberCircleButton(number: 7, onTap: () => input(7)),
          ],
        ),
        Column(
          children: [
            _NumberCircleButton(number: 2, onTap: () => input(2)),
            _NumberCircleButton(number: 5, onTap: () => input(5)),
            _NumberCircleButton(number: 8, onTap: () => input(8)),
            _NumberCircleButton(number: 0, onTap: () => input(0)),
          ],
        ),
        Column(
          children: [
            _NumberCircleButton(number: 3, onTap: () => input(3)),
            _NumberCircleButton(number: 6, onTap: () => input(6)),
            _NumberCircleButton(number: 9, onTap: () => input(9)),
            _IconCircleButton(icon: Icons.backspace, onTap: () => delete()),
          ],
        ),
      ],
    );
  }
}

///
/// 数字ボタン
///
class _NumberCircleButton extends StatelessWidget {
  const _NumberCircleButton({required this.number, required this.onTap});

  final int number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
      ),
      onPressed: onTap,
      child: Center(child: Text('$number')),
    );
  }
}

///
/// アイコンボタン
///
class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
      ),
      onPressed: onTap,
      child: Center(child: Icon(icon)),
    );
  }
}
