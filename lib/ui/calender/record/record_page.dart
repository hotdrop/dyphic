import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/calender/record/widget_meal_card.dart';
import 'package:dyphic/ui/calender/record/widget_temperature_view.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';

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
    final appSettings = Provider.of<AppSettings>(context);
    if (appSettings.isLogin) {
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _contentsView(context),
      ),
    );
  }

  Widget _rootViewAllowEdit(BuildContext context, String headerTitle) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(headerTitle),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _contentsView(context),
      ),
      floatingActionButton: _saveFloatingActionButton(context),
    );
  }

  Widget _contentsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: ListView(
        children: <Widget>[
          _mealViewArea(context),
          SizedBox(height: 16),
          _temperatureViewArea(context),
          SizedBox(height: 16),
          _medicineViewArea(context),
          SizedBox(height: 16),
          _conditionViewArea(context),
          SizedBox(height: 16),
          _memoView(context),
          SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _temperatureViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TemperatureView.morning(
            temperature: viewModel.morningTemperature,
            onEditValue: (double? newValue) {
              if (newValue != null) {
                viewModel.inputMorningTemperature(newValue);
              }
            },
          ),
          TemperatureView.night(
            temperature: viewModel.nightTemperature,
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

  Widget _conditionViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
        _contentsTitle(
          title: AppStrings.recordConditionTitle,
          icon: const Icon(Icons.sentiment_satisfied_rounded, color: AppColors.condition),
        ),
        ConditionSelectChips(
          selectIds: viewModel.selectConditionIds,
          allConditions: viewModel.allConditions,
          onChange: (Set<int> ids) => viewModel.changeSelectedCondition(ids),
        ),
        SizedBox(height: 8),
        AppTextField.multiLine(
          limitLine: 3,
          initValue: viewModel.conditionMemo,
          hintText: AppStrings.recordConditionMemoHint,
          onChanged: (String inputVal) => viewModel.inputConditionMemo(inputVal),
        ),
      ],
    );
  }

  Widget _medicineViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
        _contentsTitle(
          title: AppStrings.recordMedicalTitle,
          icon: const Icon(Icons.medical_services, color: AppColors.medicine),
        ),
        MedicineSelectChips(
          selectIds: viewModel.selectMedicineIds,
          allMedicines: viewModel.allMedicines,
          onChange: (Set<int> ids) => viewModel.changeSelectedMedicine(ids),
        ),
      ],
    );
  }

  Widget _mealViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
        _contentsTitle(
          title: AppStrings.recordMealsTitle,
          icon: const Icon(Icons.restaurant),
        ),
        Container(
          height: 150,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard(
                type: MealType.morning,
                detail: viewModel.breakfast,
                onEditValue: (String? newVal) {
                  if (newVal != null) {
                    viewModel.inputBreakfast(newVal);
                  }
                },
              ),
              const SizedBox(width: 8),
              MealCard(
                type: MealType.lunch,
                detail: viewModel.lunch,
                onEditValue: (String? newVal) {
                  if (newVal != null) {
                    viewModel.inputLunch(newVal);
                  }
                },
              ),
              const SizedBox(width: 8),
              MealCard(
                type: MealType.dinner,
                detail: viewModel.dinner,
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

  Widget _memoView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
        _contentsTitle(
          title: AppStrings.recordMemoTitle,
          icon: const Icon(Icons.notes),
        ),
        const SizedBox(height: 8),
        AppTextField.multiLine(
          limitLine: 10,
          initValue: viewModel.memo,
          onChanged: (String inputVal) {
            viewModel.inputMemo(inputVal);
          },
        ),
      ],
    );
  }

  Widget _saveFloatingActionButton(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return FloatingActionButton(
      onPressed: () {
        // キーボードが出ている場合は閉じる
        FocusScope.of(context).unfocus();
        AppProgressDialog(
          execute: viewModel.save,
          onSuccess: (bool isSuccess) {
            Navigator.pop(context, isSuccess);
          },
        );
      },
      child: const Icon(Icons.save),
    );
  }

  Widget _contentsTitle({required String title, required Icon icon}) {
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
