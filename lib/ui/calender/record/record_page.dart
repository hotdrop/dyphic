import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/widget/app_temperature.dart';
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
        create: (_) => RecordViewModel.create(_date)..init(),
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
          _medicineViewArea(context),
          // _conditionViewArea(),
          // _foodViewArea(),
          // _memoView(),
        ],
      ),
    );
  }

  Widget _temperatureViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Card(
      child: Padding(
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
      ),
    );
  }

  Widget _medicineViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _medicineViewTitle(),
            MedicineChips(
              viewModel.record.medicines,
              addOnTap: () {
                // TODO 全部表示してChoiceChipsにする
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicineViewTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 28, height: 28, child: Image.asset('res/images/ic_medical.png')),
        SizedBox(width: 8),
        Text(AppStrings.recordMedicalTitle),
      ],
    );
  }

  Widget _conditionViewArea() {
    // TODO
  }

  Widget _foodViewArea() {
    // TODO
  }

  Widget _memoView() {
    // TODO
  }
}
