import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:dyphic/ui/medicine/widgets/medicine_image.dart';
import 'package:dyphic/model/medicine.dart';

///
/// お薬用の選択chips
///
class MedicineSelectChips extends ConsumerStatefulWidget {
  const MedicineSelectChips({
    super.key,
    required this.selectIds,
    required this.medicines,
    required this.onChanged,
  });

  final Set<int> selectIds;
  final List<Medicine> medicines;
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
    return widget.medicines.map((medicine) {
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
          selectedColor: AppTheme.medicine,
        ),
      );
    }).toList();
  }
}
