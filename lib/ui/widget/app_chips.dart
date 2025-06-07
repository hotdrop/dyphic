import 'package:dyphic/ui/medicine/widgets/medicine_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';

///
/// 体調用の選択chips
///
class ConditionSelectChips extends ConsumerStatefulWidget {
  const ConditionSelectChips({
    super.key,
    required this.selectIds,
    required this.onChange,
  });

  final Set<int> selectIds;
  final void Function(Set<int>) onChange;

  @override
  ConsumerState<ConditionSelectChips> createState() => _ConditionSelectChipsState();
}

class _ConditionSelectChipsState extends ConsumerState<ConditionSelectChips> {
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
      spacing: 8.0,
      children: _makeChips(context),
    );
  }

  List<Widget> _makeChips(BuildContext context) {
    return ref.watch(conditionsProvider).map((condition) {
      return FilterChip(
        key: ValueKey<String>(condition.name),
        label: Text(condition.name, style: const TextStyle(fontSize: 12.0)),
        selected: _selectedIds.contains(condition.id) ? true : false,
        onSelected: (isSelect) => updateState(isSelect, condition.id),
        selectedColor: AppColors.condition,
      );
    }).toList();
  }
}

///
/// お薬用の選択chips
///
class MedicineSelectChips extends ConsumerStatefulWidget {
  const MedicineSelectChips({
    super.key,
    required this.selectIds,
    required this.onChanged,
  });

  final Set<int> selectIds;
  final void Function(Set<int>) onChanged;

  @override
  ConsumerState<MedicineSelectChips> createState() => _MedicineSelectChipsState();
}

class _MedicineSelectChipsState extends ConsumerState<MedicineSelectChips> {
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
      widget.onChanged(_selectedIds);
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
    // TODO これおかしい
    return ref.watch(medicineProvider).map((medicine) {
      return Tooltip(
        message: medicine.overview,
        child: FilterChip(
          avatar: ClipOval(
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: MedicineImage(id: medicine.id),
            ),
          ),
          showCheckmark: false,
          key: ValueKey<String>(medicine.name),
          label: Text(medicine.name, style: const TextStyle(fontSize: 12.0)),
          selected: _selectedIds.contains(medicine.id) ? true : false,
          onSelected: (isSelect) => updateState(isSelect, medicine.id),
          selectedColor: AppColors.medicine,
        ),
      );
    }).toList();
  }
}
