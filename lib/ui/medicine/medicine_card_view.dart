import 'package:dyphic/ui/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/medicine.dart';

class MedicineCardView extends StatelessWidget {
  MedicineCardView({@required this.medicine, @required this.onTapEvent});

  final Medicine medicine;
  final Function onTapEvent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageView(medicine.imagePath),
            _titleView(context, medicine.name),
            _oralTypeView(context, medicine.isOral),
            _colorDivider(context),
            _memoView(context, medicine.memo),
          ],
        ),
        onTap: () => onTapEvent(),
      ),
    );
  }

  Widget _imageView(String imagePath) {
    return SizedBox(
      height: 100.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.fill,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, dynamic error) => Image.asset(
                'res/images/medicine_default.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleView(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Text(title),
    );
  }

  Widget _oralTypeView(BuildContext context, bool isOral) {
    final oralStr = medicine.isOral ? AppStrings.medicinePageOralName : AppStrings.medicinePageNotOralName;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        oralStr,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _memoView(BuildContext context, String memo) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: AppText.multiLine(text: memo, maxLines: 3),
    );
  }

  Widget _colorDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(color: Theme.of(context).accentColor),
    );
  }
}
