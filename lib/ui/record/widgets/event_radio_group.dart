import 'package:flutter/material.dart';
import 'package:dyphic/model/record.dart';
import 'package:line_icons/line_icons.dart';

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
            Icon(
              Icons.not_interested_rounded,
              size: _iconSize,
              color: _getColor(EventType.none == selectValue, context),
            ),
            Radio<EventType>(value: EventType.none, groupValue: selectValue, onChanged: onSelected),
          ],
        ),
        Column(
          children: [
            Icon(
              LineIcons.hospital,
              size: _iconSize,
              color: _getColor(EventType.hospital == selectValue, context),
            ),
            Radio<EventType>(value: EventType.hospital, groupValue: selectValue, onChanged: onSelected),
          ],
        ),
        Column(
          children: [
            Icon(
              LineIcons.syringe,
              size: _iconSize,
              color: _getColor(EventType.injection == selectValue, context),
            ),
            Radio<EventType>(value: EventType.injection, groupValue: selectValue, onChanged: onSelected),
          ],
        )
      ],
    );
  }

  Color _getColor(bool selected, BuildContext context) {
    return selected ? Theme.of(context).primaryColor : Colors.grey;
  }
}
