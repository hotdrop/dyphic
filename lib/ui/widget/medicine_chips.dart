import 'package:dyphic/model/medicine.dart';
import 'package:flutter/material.dart';

class MedicineChips extends StatelessWidget {
  const MedicineChips(this._medicines, {@required this.addOnTap});

  final List<Medicine> _medicines;
  final Function addOnTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      children: _chips(),
    );
  }

  List<Widget> _chips() {
    List<Widget> widgets = [];
    if (_medicines.isNotEmpty) {
      widgets.addAll(_medicines.map((e) => _makeActionChip(e)));
    }
    widgets.add(
      IconButton(
        icon: Icon(Icons.add_circle_outline),
        onPressed: () => addOnTap(),
      ),
    );
    return widgets;
  }

  Widget _makeActionChip(Medicine medicine) {
    return ActionChip(
      label: Text(medicine.name),
      tooltip: medicine.memo,
      onPressed: () {
        // TODO 飲んだ薬から削除する
      },
    );
  }
}
