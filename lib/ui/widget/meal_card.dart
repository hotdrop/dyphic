import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/widget/meal_edit_dialog.dart';

class MealCard extends ConsumerWidget {
  const MealCard._({
    Key? key,
    required this.color,
    required this.iconImagePath,
    required this.detail,
    required this.dialogTitle,
    required this.onSubmitted,
  }) : super(key: key);

  factory MealCard.morning({required String detail, required Function(String?) onSubmitted}) {
    return MealCard._(
      color: AppColors.mealBreakFast,
      iconImagePath: AppImages.mealBreakFast,
      detail: detail,
      dialogTitle: AppStrings.recordMorningDialogTitle,
      onSubmitted: onSubmitted,
    );
  }

  factory MealCard.lunch({required String detail, required Function(String?) onSubmitted}) {
    return MealCard._(
      color: AppColors.mealLunch,
      iconImagePath: AppImages.mealLunch,
      detail: detail,
      dialogTitle: AppStrings.recordLunchDialogTitle,
      onSubmitted: onSubmitted,
    );
  }

  factory MealCard.dinner({required String detail, required Function(String?) onSubmitted}) {
    return MealCard._(
      color: AppColors.mealDinner,
      iconImagePath: AppImages.mealDinner,
      detail: detail,
      dialogTitle: AppStrings.recordDinnerDialogTitle,
      onSubmitted: onSubmitted,
    );
  }

  final Color color;
  final String iconImagePath;
  final String detail;
  final String dialogTitle;
  final Function(String?) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: color,
        elevation: 4.0,
        child: InkWell(
          onTap: () async => await _showEditDialog(context, ref),
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

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final inputValue = await MealEditDialog.show(
      context,
      title: dialogTitle,
      initValue: detail,
    );
    onSubmitted(inputValue);
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
