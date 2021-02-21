import 'package:flutter/material.dart';

class AppChips extends StatefulWidget {
  const AppChips({
    @required this.names,
    @required this.selectedNames,
    @required this.selectedColor,
    @required this.onChange,
  });

  final List<String> names;
  final List<String> selectedNames;
  final void Function(Set<String>) onChange;
  final Color selectedColor;

  @override
  _AppChipsState createState() => _AppChipsState();
}

class _AppChipsState extends State<AppChips> {
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
      direction: Axis.horizontal,
      spacing: 8.0,
      children: _makeChips(),
    );
  }

  List<Widget> _makeChips() {
    return widget.names.map((name) {
      return FilterChip(
        key: ValueKey<String>(name),
        label: Text(name),
        selected: _selectedNames.contains(name) ? true : false,
        onSelected: (isSelect) => updateState(isSelect, name),
        selectedColor: widget.selectedColor,
      );
    }).toList();
  }
}
