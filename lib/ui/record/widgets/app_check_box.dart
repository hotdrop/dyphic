import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox._(this.isWalking, this.currentValue, this.onChanged);

  factory AppCheckBox.walking({required bool initValue, required Function(bool) onChanged}) {
    return AppCheckBox._(true, initValue, onChanged);
  }

  factory AppCheckBox.toilet({required bool initValue, required Function(bool) onChanged}) {
    return AppCheckBox._(false, initValue, onChanged);
  }

  final bool isWalking;
  final bool currentValue;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: currentValue,
          onChanged: (bool? isCheck) {
            if (isCheck != null) {
              onChanged(isCheck);
            }
          },
        ),
        Text(_getLabel(), style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  String _getLabel() {
    return isWalking ? '🚶‍♀️散歩' : '💩排便';
  }
}
