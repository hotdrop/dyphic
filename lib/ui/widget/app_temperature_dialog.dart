import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppTemperatureEditDialog extends StatefulWidget {
  const AppTemperatureEditDialog({
    required this.title,
    this.initValue,
  });

  final String title;
  final double? initValue;

  @override
  _AppTemperatureEditDialogState createState() => _AppTemperatureEditDialogState();
}

class _AppTemperatureEditDialogState extends State<AppTemperatureEditDialog> {
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
      _controller.text = '**.* ℃';
    }
  }

  void input(int i) {
    setState(() {
      if (inputValues.isEmpty) {
        _controller.text = '$i*.* ℃';
        inputValues.add(i.toString());
      } else if (inputValues.length == 1) {
        _controller.text = '${inputValues.join()}$i.* ℃';
        inputValues.add(i.toString());
      } else if (inputValues.length >= 2 && inputValues.length <= 3) {
        _controller.text = '${inputValues.join()}.$i ℃';
        inputValues.add('.');
        inputValues.add(i.toString());
      } else {
        // これ以外は無視
      }
    });
  }

  void delete() {
    setState(() {
      if (inputValues.length == 1) {
        _controller.text = '**.* ℃';
        inputValues.removeLast();
      } else if (inputValues.length == 2) {
        inputValues.removeLast();
        _controller.text = '${inputValues.join()}*.* ℃';
      } else if (inputValues.length == 4) {
        inputValues.removeLast();
        inputValues.removeLast();
        _controller.text = '${inputValues.join()}.* ℃';
      } else {
        // これ以外は無視
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              '${_controller.text}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(height: 16.0),
          _keyboard(context),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: () {
            String v = inputValues.join();
            Navigator.pop<double>(context, double.parse(v));
          },
          child: Text(AppStrings.dialogOk),
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
            NumberCircleButton(number: 1, onTap: () => input(1)),
            NumberCircleButton(number: 4, onTap: () => input(4)),
            NumberCircleButton(number: 7, onTap: () => input(7)),
          ],
        ),
        Column(
          children: [
            NumberCircleButton(number: 2, onTap: () => input(2)),
            NumberCircleButton(number: 5, onTap: () => input(5)),
            NumberCircleButton(number: 8, onTap: () => input(8)),
            NumberCircleButton(number: 0, onTap: () => input(0)),
          ],
        ),
        Column(
          children: [
            NumberCircleButton(number: 3, onTap: () => input(3)),
            NumberCircleButton(number: 6, onTap: () => input(6)),
            NumberCircleButton(number: 9, onTap: () => input(9)),
            IconCircleButton(icon: Icons.backspace, onTap: () => delete()),
          ],
        ),
      ],
    );
  }
}

///
/// 数字ボタン
///
class NumberCircleButton extends StatelessWidget {
  const NumberCircleButton({required this.number, required this.onTap});

  final int number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Theme.of(context).primaryColor,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.black87, width: 1, style: BorderStyle.solid),
          )),
      onPressed: onTap,
      child: Center(child: Text('$number')),
    );
  }
}

///
/// アイコンボタン
///
class IconCircleButton extends StatelessWidget {
  const IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Theme.of(context).primaryColor,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.black87, width: 1, style: BorderStyle.solid),
          )),
      onPressed: onTap,
      child: Center(child: Icon(icon)),
    );
  }
}
