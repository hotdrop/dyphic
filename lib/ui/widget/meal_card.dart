import 'package:flutter/material.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/widget/meal_edit_dialog.dart';

class MealCard extends StatelessWidget {
  const MealCard._({
    Key? key,
    required this.color,
    required this.iconImagePath,
    required this.detail,
    required this.isEditable,
    required this.dialogTitle,
    required this.onEdit,
  }) : super(key: key);

  factory MealCard.morning({required String detail, required bool isEditable, required Function(String?) onTap}) {
    return MealCard._(
      color: AppColors.mealBreakFast,
      iconImagePath: AppImages.mealBreakFast,
      detail: detail,
      isEditable: isEditable,
      dialogTitle: AppStrings.recordMorningDialogTitle,
      onEdit: onTap,
    );
  }

  factory MealCard.lunch({required String detail, required bool isEditable, required Function(String?) onTap}) {
    return MealCard._(
      color: AppColors.mealLunch,
      iconImagePath: AppImages.mealLunch,
      detail: detail,
      isEditable: isEditable,
      dialogTitle: AppStrings.recordLunchDialogTitle,
      onEdit: onTap,
    );
  }

  factory MealCard.dinner({required String detail, required bool isEditable, required Function(String?) onEdit}) {
    return MealCard._(
      color: AppColors.mealDinner,
      iconImagePath: AppImages.mealDinner,
      detail: detail,
      isEditable: isEditable,
      dialogTitle: AppStrings.recordDinnerDialogTitle,
      onEdit: onEdit,
    );
  }

  final Color color;
  final String iconImagePath;
  final String detail;
  final bool isEditable;
  final String dialogTitle;
  final Function(String?) onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: color,
        elevation: 4.0,
        child: InkWell(
          onTap: () async {
            final inputValue = await MealEditDialog.show(context, title: dialogTitle, initValue: detail, isEditable: isEditable);
            onEdit(inputValue);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Image.asset(iconImagePath)),
                _detailLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailLabel() {
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
}
