import 'package:flutter/material.dart';

import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/ui/widget/app_meal_edit_dialog.dart';

enum MealType { morning, lunch, dinner }

class MealCard extends StatelessWidget {
  const MealCard({
    required this.type,
    required this.detail,
    required this.onEditValue,
  });

  final MealType type;
  final String detail;
  final Function(String?) onEditValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Ink(
        decoration: _decorationEachType(),
        child: InkWell(
          onTap: () async {
            String dialogTitle = _dialogTitle();
            final inputValue = await showDialog<String>(
              context: context,
              builder: (context) {
                return AppMealEditDialog(
                  title: dialogTitle,
                  initValue: detail,
                );
              },
            );
            onEditValue(inputValue);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleIcon(),
                SizedBox(height: 4.0),
                _detailLabel(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decorationEachType() {
    Color typeColor;
    Color typeColorThin;
    switch (type) {
      case MealType.morning:
        typeColor = AppColors.mealBreakFast;
        typeColorThin = AppColors.mealBreakFastThin;
        break;
      case MealType.lunch:
        typeColor = AppColors.mealLunch;
        typeColorThin = AppColors.mealLunchThin;
        break;
      case MealType.dinner:
        typeColor = AppColors.mealDinner;
        typeColorThin = AppColors.mealDinnerThin;
        break;
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Colors.white,
          typeColorThin,
          typeColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    );
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

    return Image.asset(iconPath);
  }

  Widget _detailLabel(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          detail,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.mealTextDetail),
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
