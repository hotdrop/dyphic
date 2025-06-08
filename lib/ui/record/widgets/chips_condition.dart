import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:dyphic/model/condition.dart';

///
/// 体調用の選択chips
///
class ConditionSelectChips extends ConsumerStatefulWidget {
  const ConditionSelectChips({
    super.key,
    required this.selectIds,
    required this.conditions,
    required this.onChange,
  });

  final Set<int> selectIds;
  final List<Condition> conditions;
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
    return widget.conditions.map((condition) {
      return FilterChip(
        key: ValueKey<String>(condition.name),
        label: Text(condition.name, style: const TextStyle(fontSize: 12.0)),
        selected: _selectedIds.contains(condition.id) ? true : false,
        onSelected: (isSelect) => updateState(isSelect, condition.id),
        selectedColor: AppTheme.condition,
      );
    }).toList();
  }
}
