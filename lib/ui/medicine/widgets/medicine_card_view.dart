import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:dyphic/ui/medicine/widgets/medicine_image.dart';
import 'package:dyphic/model/medicine.dart';

class MedicineCardView extends StatelessWidget {
  const MedicineCardView({
    super.key,
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
        leading: MedicineImage(id: medicine.id),
        title: Text(medicine.name),
        subtitle: Text(
          medicine.overview,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _ViewMemo(medicine.memo)),
              if (isEditable)
                TextButton(
                  onPressed: () => onTapEvent(),
                  child: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewMemo extends StatelessWidget {
  const _ViewMemo(this.memo);

  final String memo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Text(
        memo,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
