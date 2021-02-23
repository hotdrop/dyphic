import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_meal_card.dart';
import 'package:dyphic/ui/widget/app_temperature.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';

class RecordPage extends StatelessWidget {
  const RecordPage(this._date);

  final DateTime _date;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordViewModel>(
      create: (_) => RecordViewModel.create(_date),
      builder: (context, _) {
        final pageState = context.select<RecordViewModel, PageLoadingState>((vm) => vm.pageState);
        if (pageState.isLoadSuccess) {
          return _loadSuccessView(context);
        } else {
          return _nowLoadingView();
        }
      },
      child: _nowLoadingView(),
    );
  }

  Widget _nowLoadingView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Record.formatDate(_date)),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Record.formatDate(_date)),
      ),
      body: _contentsView(context),
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
          AppTemperature.morning(
              temperature: viewModel.inputRecord.morningTemperature,
              onTap: () {
                // TODO 入力ダイアログを出して値を更新する
              }),
          AppTemperature.night(
              temperature: viewModel.inputRecord.nightTemperature,
              onTap: () {
                // TODO 入力ダイアログを出して値を更新する
              }),
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
          icon: Icon(Icons.sentiment_satisfied_rounded, color: AppColors.condition),
        ),
        AppChips(
          names: viewModel.allConditionNames,
          selectedNames: viewModel.inputRecord.selectConditionNames,
          selectedColor: AppColors.condition,
          onChange: (selectedNamesSet) {
            viewModel.changeSelectedCondition(selectedNamesSet.toList());
          },
        ),
        SizedBox(height: 8),
        AppTextField.multiLine(
          limitLine: 3,
          initValue: viewModel.inputRecord.conditionMemo,
          hintText: AppStrings.recordConditionMemoHint,
          onChanged: (String inputVal) {
            viewModel.inputConditionMemo(inputVal);
          },
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
          icon: Icon(Icons.medical_services, color: AppColors.medicine),
        ),
        AppChips(
          names: viewModel.allMedicineNames,
          selectedNames: viewModel.inputRecord.selectMedicineNames,
          selectedColor: AppColors.medicine,
          onChange: (selectedNamesSet) {
            viewModel.changeSelectedMedicine(selectedNamesSet.toList());
          },
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
          icon: Icon(Icons.restaurant),
        ),
        Container(
          height: 150,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard(
                type: MealType.morning,
                detail: viewModel.inputRecord.breakfast,
                onTap: () {
                  // TODO 入力ダイアログを出して値を更新する
                },
              ),
              SizedBox(width: 8),
              MealCard(
                type: MealType.lunch,
                detail: viewModel.inputRecord.lunch,
                onTap: () {
                  // TODO 入力ダイアログを出して値を更新する
                },
              ),
              SizedBox(width: 8),
              MealCard(
                type: MealType.dinner,
                detail: viewModel.inputRecord.dinner,
                onTap: () {
                  // TODO 入力ダイアログを出して値を更新する
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _memoView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
        _contentsTitle(
          title: AppStrings.recordMemoTitle,
          icon: Icon(Icons.notes),
        ),
        SizedBox(height: 8),
        AppTextField.multiLine(
          limitLine: 10,
          initValue: viewModel.inputRecord.memo,
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
      child: Icon(Icons.save),
      onPressed: () async {
        final dialog = AppDialog.createInfo(
          title: AppStrings.recordSaveDialogTitle,
          description: AppStrings.recordSaveDialogDetail,
          successMessage: AppStrings.recordSaveDialogSuccess,
          errorMessage: AppStrings.recordSaveDialogError,
          onOkPress: viewModel.save,
          onSuccessOkPress: () {
            Navigator.pop(context, true);
          },
        );
        await dialog.show(context);
      },
    );
  }

  Widget _contentsTitle({String title, Icon icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
