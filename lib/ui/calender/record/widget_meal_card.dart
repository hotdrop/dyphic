import 'package:flutter/material.dart';

import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/ui/calender/record/widget_meal_edit_dialog.dart';

enum MealType { morning, lunch, dinner }

class MealCard extends StatelessWidget {
  const MealCard({
    required this.type,
    required this.detail,
    required this.isLogin,
    required this.onEditValue,
  });

  final MealType type;
  final String detail;
  final bool isLogin;
  final Function(String?) onEditValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: _shadowColorEachType(),
        elevation: 4.0,
        child: InkWell(
          onTap: () async {
            String dialogTitle = _dialogTitle();
            final inputValue = await showDialog<String>(
              context: context,
              builder: (context) => MealEditDialog(title: dialogTitle, isLogin: isLogin, initValue: detail),
            );
            onEditValue(inputValue);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleIcon(),
                _detailLabel(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _shadowColorEachType() {
    switch (type) {
      case MealType.morning:
        return AppColors.mealBreakFast;
      case MealType.lunch:
        return AppColors.mealLunch;
      case MealType.dinner:
        return AppColors.mealDinner;
    }
  }

  Widget _titleIcon() {
    String iconPath;
    switch (type) {
      case MealType.morning:
        iconPath = 'res/images/ic_breakfast.png';
        break;
      case MealType.lunch:
        iconPath = 'res/images/ic_lunch.png';
        break;
      case MealType.dinner:
        iconPath = 'res/images/ic_dinner.png';
        break;
    }

    return Center(child: Image.asset(iconPath));
  }

  Widget _detailLabel(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          detail,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _dialogTitle() {
    switch (type) {
      case MealType.morning:
        return AppStrings.recordMorningDialogTitle;
      case MealType.lunch:
        return AppStrings.recordLunchDialogTitle;
      default:
        return AppStrings.recordDinnerDialogTitle;
    }
  }
}
