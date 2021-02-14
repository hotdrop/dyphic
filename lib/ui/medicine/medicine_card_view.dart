import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/medicine.dart';
import 'package:flutter/material.dart';

class MedicineCardView extends StatelessWidget {
  MedicineCardView(this._medicine);

  final Medicine _medicine;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageView(_medicine.imagePath),
            _titleView(context, _medicine.name),
            _oralTypeView(context, _medicine.isOral),
            _colorDivider(context),
            _memoView(context, _medicine.memo),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _imageView(String imagePath) {
    return SizedBox(
      height: 120.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.fill,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, dynamic error) => Image.asset('res/images/medicine_default.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleView(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Widget _oralTypeView(BuildContext context, bool isOral) {
    final oralStr = _medicine.isOral ? AppStrings.medicinePageOralName : AppStrings.medicinePageNotOralName;
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(
        oralStr,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _memoView(BuildContext context, String memo) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(
        memo,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _colorDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(color: Theme.of(context).accentColor),
    );
  }
}
