import 'package:dyphic/model/record.dart';
import 'package:flutter/material.dart';

///
/// 体調アイコン
///
class ConditionIcon extends StatelessWidget {
  const ConditionIcon._(this._type, this._size, this._selected);

  factory ConditionIcon.onRadioGroup({required ConditionType type, required double size, required bool selected}) {
    return ConditionIcon._(type, size, selected);
  }

  factory ConditionIcon.onCalendar({required ConditionType type, required double size}) {
    return ConditionIcon._(type, size, true);
  }

  final ConditionType _type;
  final double _size;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case ConditionType.bad:
        return Icon(
          Icons.sentiment_very_dissatisfied_sharp,
          color: _selected ? Colors.red : Colors.grey,
          size: _size,
        );
      case ConditionType.normal:
        return Icon(
          Icons.sentiment_satisfied_sharp,
          color: _selected ? Colors.orange : Colors.grey,
          size: _size,
        );
      case ConditionType.good:
        return Icon(
          Icons.sentiment_very_satisfied_sharp,
          color: _selected ? Colors.blue : Colors.grey,
          size: _size,
        );
    }
  }
}
