import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppCheckBox extends StatefulWidget {
  AppCheckBox._(this.isWalking, this.initValue, this.onChanged);

  factory AppCheckBox.walking({required bool initValue, required Function(bool) onChanged}) {
    return AppCheckBox._(true, initValue, onChanged);
  }

  factory AppCheckBox.toilet({required bool initValue, required Function(bool) onChanged}) {
    return AppCheckBox._(false, initValue, onChanged);
  }

  final bool isWalking;
  final bool initValue;
  final Function(bool) onChanged;

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  bool _currentValue = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _currentValue,
          onChanged: (bool? isCheck) {
            if (isCheck != null) {
              setState(() {
                _currentValue = isCheck;
              });
              widget.onChanged(isCheck);
            }
          },
        ),
        _viewLabel(),
      ],
    );
  }

  Widget _viewLabel() {
    if (widget.isWalking) {
      return Text(AppStrings.recordWalkingLabel);
    } else {
      return Text(AppStrings.recordToiletLabel);
    }
  }
}
