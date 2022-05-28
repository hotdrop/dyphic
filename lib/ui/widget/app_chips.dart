import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';

///
/// 体調用の選択chips
///
class ConditionSelectChips extends ConsumerWidget {
  const ConditionSelectChips({
    Key? key,
    required this.selectIds,
    required this.onChange,
  }) : super(key: key);

  final Set<int> selectIds;
  final void Function(Set<int>) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      children: ref
          .watch(conditionsProvider)
          .map((c) => FilterChip(
                key: ValueKey<String>(c.name),
                label: Text(c.name, style: const TextStyle(fontSize: 12.0)),
                selected: selectIds.contains(c.id) ? true : false,
                onSelected: (isSelect) => _onSelected(isSelect, c.id),
                selectedColor: AppColors.condition,
              ))
          .toList(),
    );
  }

  void _onSelected(bool isSelect, int id) {
    final tmp = selectIds;
    if (isSelect) {
      tmp.add(id);
    } else {
      tmp.remove(id);
    }
    onChange(tmp);
  }
}

///
/// お薬用の選択chips
///
class MedicineSelectChips extends ConsumerWidget {
  const MedicineSelectChips({
    Key? key,
    required this.selectIds,
    required this.onChanged,
  }) : super(key: key);

  final Set<int> selectIds;
  final void Function(Set<int>) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 4.0,
      children: ref
          .watch(medicineProvider)
          .map((m) => Tooltip(
                message: m.overview,
                child: FilterChip(
                  avatar: ClipOval(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: AppImage.icon(path: m.imagePath),
                    ),
                  ),
                  showCheckmark: false,
                  key: ValueKey<String>(m.name),
                  label: Text(m.name, style: const TextStyle(fontSize: 12.0)),
                  selected: selectIds.contains(m.id) ? true : false,
                  onSelected: (isSelect) => updateState(isSelect, m.id),
                  selectedColor: AppColors.medicine,
                ),
              ))
          .toList(),
    );
  }

  void updateState(bool isSelect, int id) {
    final tmp = selectIds;
    if (isSelect) {
      tmp.add(id);
    } else {
      tmp.remove(id);
    }
    onChanged(tmp);
  }
}
