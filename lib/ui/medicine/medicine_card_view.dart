import 'package:dyphic/ui/widget/app_image.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'package:dyphic/ui/widget/app_divider.dart';
import 'package:dyphic/ui/widget/app_text.dart';
import 'package:dyphic/model/medicine.dart';

class MedicineCardView extends StatelessWidget {
  MedicineCardView({@required this.medicine, @required this.isEditPermission, @required this.onTapEvent});

  final Medicine medicine;
  final bool isEditPermission;
  final Function onTapEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ExpansionTileCard(
        leading: _imageView(),
        title: Text(medicine.name),
        subtitle: AppText.normal(text: medicine.overview),
        children: [
          DividerThemeColor.create(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _memoView(context)),
              if (isEditPermission) _editButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageView() {
    return AppImage.icon(path: medicine.imagePath);
  }

  Widget _memoView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: AppText.multiLine(text: medicine.memo, maxLines: 3),
    );
  }

  Widget _editButton() {
    return TextButton(
      child: Icon(Icons.edit),
      onPressed: () => onTapEvent(),
    );
  }
}
