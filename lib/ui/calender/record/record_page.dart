import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/calender/record/widget_meal_card.dart';
import 'package:dyphic/ui/calender/record/widget_temperature_view.dart';
import 'package:dyphic/ui/widget/app_check_box.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatelessWidget {
  const RecordPage(this._date);

  final DateTime _date;

  @override
  Widget build(BuildContext context) {
    final headerTitle = DateFormat(AppStrings.recordPageTitleDateFormat).format(_date);
    return ChangeNotifierProvider<RecordViewModel>(
      create: (_) => RecordViewModel.create(_date),
      builder: (context, _) {
        final pageState = context.select<RecordViewModel, PageLoadingState>((vm) => vm.pageState);
        if (pageState.isLoadSuccess) {
          return _loadSuccessView(context, headerTitle);
        } else {
          return _nowLoadingView(headerTitle);
        }
      },
      child: _nowLoadingView(headerTitle),
    );
  }

  Widget _nowLoadingView(String headerTitle) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(headerTitle),
      ),
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context, String headerTitle) {
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    if (isLogin) {
      return _rootViewAllowEdit(context, headerTitle);
    } else {
      return _rootViewDeniedEdit(context, headerTitle);
    }
  }

  Widget _rootViewDeniedEdit(BuildContext context, String headerTitle) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(headerTitle),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _contentsView(context),
      ),
    );
  }

  Widget _rootViewAllowEdit(BuildContext context, String headerTitle) {
    return WillPopScope(
      onWillPop: () async {
        final viewModel = context.read<RecordViewModel>();
        if (viewModel.isUpdate) {
          Navigator.pop(context, true);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(headerTitle),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _contentsView(context),
        ),
      ),
    );
  }

  Widget _contentsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
      child: ListView(
        children: <Widget>[
          _mealViewArea(context),
          _temperatureViewArea(context),
          _conditionViewArea(context),
          const SizedBox(height: 16.0),
          _medicineViewArea(context),
          const SizedBox(height: 16.0),
          _memoView(context),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _mealViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard(
                type: MealType.morning,
                detail: viewModel.breakfast,
                isLogin: isLogin,
                onEditValue: (String? newVal) {
                  if (newVal != null) {
                    viewModel.inputBreakfast(newVal);
                  }
                },
              ),
              const SizedBox(width: 4),
              MealCard(
                type: MealType.lunch,
                detail: viewModel.lunch,
                isLogin: isLogin,
                onEditValue: (String? newVal) {
                  if (newVal != null) {
                    viewModel.inputLunch(newVal);
                  }
                },
              ),
              const SizedBox(width: 4),
              MealCard(
                type: MealType.dinner,
                detail: viewModel.dinner,
                isLogin: isLogin,
                onEditValue: (String? newVal) {
                  if (newVal != null) {
                    viewModel.inputDinner(newVal);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _temperatureViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: viewModel.morningTemperature,
            isLogin: isLogin,
            onEditValue: (double? newValue) {
              if (newValue != null) {
                viewModel.inputMorningTemperature(newValue);
              }
            },
          ),
          TemperatureView.night(
            temperature: viewModel.nightTemperature,
            isLogin: isLogin,
            onEditValue: (double? newValue) {
              if (newValue != null) {
                viewModel.inputNightTemperature(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _medicineViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isDarkMode = context.select<AppSettings, bool>((m) => m.isDarkMode);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _contentsTitle(
              title: AppStrings.recordMedicalTitle,
              icon: AppIcon.medicine(isDarkMode),
            ),
            const Divider(),
            MedicineSelectChips(
              selectIds: viewModel.selectMedicineIds,
              allMedicines: viewModel.allMedicines,
              onChange: (Set<int> ids) => viewModel.changeSelectedMedicine(ids),
            ),
            OutlinedButton(
              onPressed: (isLogin)
                  ? () async {
                      // キーボードが出ている場合は閉じる
                      FocusScope.of(context).unfocus();
                      await AppProgressDialog(execute: viewModel.saveMedicine).show(context);
                    }
                  : null,
              child: Text(AppStrings.recordMedicineSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conditionViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isDarkMode = context.select<AppSettings, bool>((m) => m.isDarkMode);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _contentsTitle(
              title: AppStrings.recordConditionTitle,
              icon: AppIcon.condition(isDarkMode),
            ),
            const Divider(),
            ConditionSelectChips(
              selectIds: viewModel.selectConditionIds,
              allConditions: viewModel.allConditions,
              onChange: (Set<int> ids) => viewModel.changeSelectedCondition(ids),
            ),
            const Divider(),
            _viewCheckBoxes(context),
            MultiLineTextField(
              label: AppStrings.recordConditionMemoTitle,
              initValue: viewModel.conditionMemo,
              limitLine: 10,
              hintText: AppStrings.recordConditionMemoHint,
              onChanged: viewModel.inputConditionMemo,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: (isLogin)
                  ? () async {
                      // キーボードが出ている場合は閉じる
                      FocusScope.of(context).unfocus();
                      await AppProgressDialog(execute: viewModel.saveCondition).show(context);
                    }
                  : null,
              child: const Text(AppStrings.recordConditionSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewCheckBoxes(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: viewModel.isWalking,
          onChanged: (bool? isCheck) => viewModel.inputIsWalking(isCheck),
        ),
        AppCheckBox.toilet(
          initValue: viewModel.isToilet,
          onChanged: (bool? isCheck) => viewModel.inputIsToilet(isCheck),
        ),
      ],
    );
  }

  Widget _memoView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MultiLineTextField(
              label: AppStrings.recordMemoTitle,
              initValue: viewModel.memo,
              limitLine: 10,
              hintText: AppStrings.recordMemoHint,
              onChanged: viewModel.inputMemo,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: (isLogin)
                  ? () async {
                      // キーボードが出ている場合は閉じる
                      FocusScope.of(context).unfocus();
                      await AppProgressDialog(execute: viewModel.saveMemo).show(context);
                    }
                  : null,
              child: const Text(AppStrings.recordMemoSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentsTitle({required String title, required AppIcon icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
