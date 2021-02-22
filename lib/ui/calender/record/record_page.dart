import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
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
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(Record.formatDate(_date))),
      body: ChangeNotifierProvider<RecordViewModel>(
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          // TODO 内容を保存する
        },
      ),
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
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
              temperature: viewModel.record.morningTemperature,
              onTap: () {
                // TODO 値更新
              }),
          AppTemperature.night(
              temperature: viewModel.record.nightTemperature,
              onTap: () {
                // TODO 値更新
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
          selectedNames: viewModel.selectConditionNames,
          selectedColor: AppColors.condition,
          onChange: (selectedNamesSet) {
            viewModel.changeSelectedMedicine(selectedNamesSet.toList());
          },
        ),
        SizedBox(height: 8),
        AppTextField.multiLine(
          limitLine: 3,
          initValue: viewModel.record.conditionMemo,
          hintText: AppStrings.recordConditionMemoHint,
          onChanged: null, // TODO 未実装
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
          selectedNames: viewModel.takenMedicineNames,
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
    final record = viewModel.record;
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
                detail: record.breakfast,
                onTap: () {
                  // TODO テキストダイアログを表示する
                },
              ),
              SizedBox(width: 8),
              MealCard(
                type: MealType.lunch,
                detail: record.lunch,
                onTap: () {
                  // TODO テキストダイアログを表示する
                },
              ),
              SizedBox(width: 8),
              MealCard(
                type: MealType.dinner,
                detail: record.dinner,
                onTap: () {
                  // TODO テキストダイアログを表示する
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
          initValue: viewModel.record.memo,
          onChanged: null, // TODO 未実装
        ),
      ],
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
