import 'package:dyphic/model/record.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:flutter/material.dart';

class EventRadioGroup extends StatelessWidget {
  const EventRadioGroup({
    super.key,
    required this.selectValue,
    required this.onSelected,
  });

  final EventType selectValue;
  final Function(EventType?) onSelected;
  static const double _iconSize = 50;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.not_interested_rounded, size: _iconSize, color: _getColor(EventType.none == selectValue)),
            Radio<EventType>(value: EventType.none, groupValue: selectValue, onChanged: onSelected),
          ],
        ),
        Column(
          children: [
            Icon(Icons.medical_information_outlined, size: _iconSize, color: _getColor(EventType.hospital == selectValue)),
            Radio<EventType>(value: EventType.hospital, groupValue: selectValue, onChanged: onSelected),
          ],
        ),
        Column(
          children: [
            Icon(Icons.medical_services, size: _iconSize, color: _getColor(EventType.injection == selectValue)),
            Radio<EventType>(value: EventType.injection, groupValue: selectValue, onChanged: onSelected),
          ],
        )
      ],
    );
  }

  Color _getColor(bool selected) {
    return selected ? AppColors.themeColor : Colors.grey;
  }
}
