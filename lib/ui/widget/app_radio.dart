import 'package:dalico/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppRadio extends StatefulWidget {
  AppRadio({@required this.initSelectedOral, @required this.onChange});

  final bool initSelectedOral;
  final Function(bool) onChange;

  @override
  _AppRadioState createState() => _AppRadioState();
}

class _AppRadioState extends State<AppRadio> {
  int radioOral = 1;
  int radioNotOral = 2;
  int selectedRadioValue;

  @override
  void initState() {
    super.initState();
    selectedRadioValue = widget.initSelectedOral ? radioOral : radioNotOral;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: radioOral,
          groupValue: selectedRadioValue,
          onChanged: (int v) {
            widget.onChange(true);
            setState(() {
              selectedRadioValue = radioOral;
            });
          },
        ),
        Text(AppStrings.medicineOralLabel),
        Radio(
            value: radioNotOral,
            groupValue: selectedRadioValue,
            onChanged: (int v) {
              widget.onChange(false);
              setState(() {
                selectedRadioValue = radioNotOral;
              });
            }),
        Text(AppStrings.medicineNotOralLabel),
      ],
    );
  }
}
