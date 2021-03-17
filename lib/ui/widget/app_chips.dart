import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:provider/provider.dart';

///
/// 体調用の選択chips
///
class ConditionSelectChips extends StatefulWidget {
  const ConditionSelectChips({
    required this.selectIds,
    required this.allConditions,
    required this.onChange,
  });

  final Set<int> selectIds;
  final List<Condition> allConditions;
  final void Function(Set<int>) onChange;

  @override
  _ConditionSelectChipsState createState() => _ConditionSelectChipsState();
}

class _ConditionSelectChipsState extends State<ConditionSelectChips> {
  Set<int> _selectedIds = <int>{};

  @override
  void initState() {
    super.initState();
    if (widget.selectIds.isNotEmpty) {
      _selectedIds = widget.selectIds.toSet();
    }
  }

  void updateState(bool isSelect, int id) {
    setState(() {
      if (isSelect) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
      widget.onChange(_selectedIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      children: _makeChips(context),
    );
  }

  List<Widget> _makeChips(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final conditionColor = (appSettings.isDarkMode) ? AppColors.conditionNight : AppColors.condition;
    return widget.allConditions.map((condition) {
      return FilterChip(
        key: ValueKey<String>(condition.name),
        label: Text(condition.name, style: TextStyle(fontSize: 12.0)),
        selected: _selectedIds.contains(condition.id) ? true : false,
        onSelected: (isSelect) => updateState(isSelect, condition.id),
        selectedColor: conditionColor,
      );
    }).toList();
  }
}

///
/// お薬用の選択chips
///
class MedicineSelectChips extends StatefulWidget {
  const MedicineSelectChips({
    required this.selectIds,
    required this.allMedicines,
    required this.onChange,
  });

  final Set<int> selectIds;
  final List<Medicine> allMedicines;
  final void Function(Set<int>) onChange;

  @override
  _MedicineSelectChipsState createState() => _MedicineSelectChipsState();
}

class _MedicineSelectChipsState extends State<MedicineSelectChips> {
  Set<int> _selectedIds = <int>{};

  @override
  void initState() {
    super.initState();
    if (widget.selectIds.isNotEmpty) {
      _selectedIds = widget.selectIds;
    }
  }

  void updateState(bool isSelect, int id) {
    setState(() {
      if (isSelect) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
      widget.onChange(_selectedIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 4.0,
      children: _makeChips(context),
    );
  }

  List<Widget> _makeChips(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final medicineColor = (appSettings.isDarkMode) ? AppColors.medicineNight : AppColors.medicine;
    return widget.allMedicines.map((medicine) {
      return Tooltip(
        message: medicine.overview,
        child: FilterChip(
          avatar: ClipOval(
            child: Container(
              width: 30.0,
              height: 30.0,
              child: AppImage.icon(path: medicine.imagePath),
            ),
          ),
          showCheckmark: false,
          key: ValueKey<String>(medicine.name),
          label: Text(medicine.name, style: TextStyle(fontSize: 12.0)),
          selected: _selectedIds.contains(medicine.id) ? true : false,
          onSelected: (isSelect) => updateState(isSelect, medicine.id),
          selectedColor: medicineColor,
        ),
      );
    }).toList();
  }
}
