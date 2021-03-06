import 'package:dyphic/ui/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            _imageView(),
            _titleView(context),
            _oralTypeView(context),
            _colorDivider(context),
            _memoView(context),
          ],
        ),
        onTap: () => onTapEvent(),
      ),
    );
  }

  Widget _imageView() {
    return SizedBox(
      height: 100.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: medicine.imagePath,
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

  Widget _titleView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Text(medicine.name),
    );
  }

  Widget _oralTypeView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        medicine.toTypeString(),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _memoView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: AppText.multiLine(text: medicine.memo, maxLines: 3),
    );
  }

  Widget _colorDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(color: Theme.of(context).accentColor),
    );
  }
}
