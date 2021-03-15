import 'package:dyphic/ui/widget/app_image.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'package:dyphic/model/medicine.dart';

class MedicineCardView extends StatelessWidget {
  MedicineCardView({
    required this.medicine,
    required this.isEditable,
    required this.onTapEvent,
  });

  final Medicine medicine;
  final bool isEditable;
  final Function onTapEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ExpansionTileCard(
        leading: AppImage.icon(path: medicine.imagePath),
        title: Text(medicine.name),
        subtitle: Text(
          medicine.overview,
          style: Theme.of(context).textTheme.caption,
        ),
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _memoView(context)),
              if (isEditable) _editButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memoView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Text(
        medicine.memo,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    return TextButton(
      onPressed: () => onTapEvent(),
      child: Icon(Icons.edit, color: Theme.of(context).accentColor),
    );
  }
}
