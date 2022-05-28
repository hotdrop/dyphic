import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:flutter/material.dart';

class MedicineTypeRadio extends StatefulWidget {
  const MedicineTypeRadio({
    Key? key,
    required this.initSelectedType,
    required this.onChange,
  }) : super(key: key);

  final MedicineType initSelectedType;
  final Function(MedicineType) onChange;

  @override
  State<MedicineTypeRadio> createState() => _MedicineTypeRadioState();
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: radioOral,
          groupValue: selectedRadioValue,
          onChanged: (int? v) {
            widget.onChange(MedicineType.oral);
            setState(() {
              selectedRadioValue = radioOral;
            });
          },
        ),
        const Text(AppStrings.medicineOralLabel),
        Radio(
            value: radioNotOral,
            groupValue: selectedRadioValue,
            onChanged: (int? v) {
              widget.onChange(MedicineType.notOral);
              setState(() {
                selectedRadioValue = radioNotOral;
              });
            }),
        const Text(AppStrings.medicineNotOralLabel),
      ],
    );
  }
}
