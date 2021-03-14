import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:flutter/material.dart';

class MedicineTypeRadio extends StatefulWidget {
  MedicineTypeRadio({required this.initSelectedType, required this.onChange});

  final MedicineType initSelectedType;
  final Function(MedicineType) onChange;

  @override
  _MedicineTypeRadioState createState() => _MedicineTypeRadioState();
}

class _MedicineTypeRadioState extends State<MedicineTypeRadio> {
  int radioOral = 1;
  int radioNotOral = 2;
  late int selectedRadioValue;

  @override
  void initState() {
    super.initState();
    switch (widget.initSelectedType) {
      case MedicineType.oral:
        selectedRadioValue = radioOral;
        break;
      default:
        selectedRadioValue = radioNotOral;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: radioOral,
          groupValue: selectedRadioValue,
          activeColor: Theme.of(context).accentColor,
          onChanged: (int? v) {
            widget.onChange(MedicineType.oral);
            setState(() {
              selectedRadioValue = radioOral;
            });
          },
        ),
        Text(AppStrings.medicineOralLabel),
        Radio(
            value: radioNotOral,
            groupValue: selectedRadioValue,
            activeColor: Theme.of(context).accentColor,
            onChanged: (int? v) {
              widget.onChange(MedicineType.notOral);
              setState(() {
                selectedRadioValue = radioNotOral;
              });
            }),
        Text(AppStrings.medicineNotOralLabel),
      ],
    );
  }
}
