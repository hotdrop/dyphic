import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_temperature.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:dyphic/ui/widget/app_widget.dart';
import 'package:dyphic/ui/widget/medicine_chips.dart';
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
          _temperatureViewArea(context),
          _conditionViewArea(context),
          _medicineViewArea(context),
          // _foodViewArea(),
          // _memoView(),
          // _saveButton(),
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 12),
      child: Column(
        children: [
          _contentsTitle(
            title: AppStrings.recordConditionTitle,
            icon: Icon(Icons.sentiment_satisfied_rounded, color: AppColors.condition),
          ),
          DividerThemeColor.createWithPadding(),
          AppChips(
            names: viewModel.allConditionNames,
            selectedNames: viewModel.selectConditionNames,
            selectedColor: AppColors.condition,
            onChange: (selectedNamesSet) {
              viewModel.changeSelectedMedicine(selectedNamesSet.toList());
            },
          ),
          _contentsTitle(
            title: AppStrings.recordConditionMemoTitle,
            icon: Icon(Icons.note, color: AppColors.condition),
          ),
          SizedBox(height: 8),
          AppTextField.multiLine(
            limitLine: 3,
            initValue: viewModel.record.conditionMemo,
            onChanged: null, // TODO 未実装
          ),
        ],
      ),
    );
  }

  Widget _medicineViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 12),
      child: Column(
        children: [
          _contentsTitle(
            title: AppStrings.recordMedicalTitle,
            icon: Icon(Icons.medical_services, color: AppColors.medicine),
          ),
          DividerThemeColor.createWithPadding(),
          AppChips(
            names: viewModel.allMedicineNames,
            selectedNames: viewModel.takenMedicineNames,
            selectedColor: AppColors.medicine,
            onChange: (selectedNamesSet) {
              viewModel.changeSelectedMedicine(selectedNamesSet.toList());
            },
          ),
        ],
      ),
    );
  }

  Widget _foodViewArea() {
    // TODO
  }

  Widget _memoView() {
    // TODO
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
