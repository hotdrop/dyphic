import 'package:dyphic/model/medicine.dart';
import 'package:flutter/material.dart';

class MedicineChips extends StatefulWidget {
  const MedicineChips({
    @required this.medicines,
    @required this.selectedNames,
    @required this.onChange,
  });

  final List<Medicine> medicines;
  final List<String> selectedNames;
  final void Function(Set<String>) onChange;

  @override
  _MedicineChipsState createState() => _MedicineChipsState();
}

class _MedicineChipsState extends State<MedicineChips> {
  Set<String> _selectedNames;

  @override
  void initState() {
    super.initState();
    if (widget.selectedNames.isNotEmpty) {
      _selectedNames = widget.selectedNames.toSet();
    } else {
      _selectedNames = <String>{};
    }
  }

  void updateState(bool isSelect, String name) {
    setState(() {
      if (isSelect) {
        _selectedNames.add(name);
      } else {
        _selectedNames.remove(name);
      }
      widget.onChange(_selectedNames);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      children: _makeChips(),
    );
  }

  List<Widget> _makeChips() {
    return widget.medicines.map((e) => e.name).map((name) {
      return FilterChip(
        key: ValueKey<String>(name),
        label: Text(name),
        selected: _selectedNames.contains(name) ? true : false,
        onSelected: (isSelect) => updateState(isSelect, name),
        selectedColor: Theme.of(context).accentColor.withOpacity(0.6),
      );
    }).toList();
  }
}
