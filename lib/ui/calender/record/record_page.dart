import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/calender/record/widget_meal_card.dart';
import 'package:dyphic/ui/calender/record/widget_temperature_view.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_simple_dialog.dart';
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: _contentsView(context),
      ),
    );
  }

  Widget _rootViewAllowEdit(BuildContext context, String headerTitle) {
    return WillPopScope(
      onWillPop: () async {
        // TODO このダイアログうざいので各項目を編集したら自動で保存するようにしたい。
        final viewModel = context.read<RecordViewModel>();
        if (viewModel.isEditNotSaved) {
          AppDialog.okAndCancel(
            message: AppStrings.recordNotEditSavedWhenCloseScreen,
            onOk: () {
              Navigator.pop(context, false);
            },
          ).show(context);
          return false;
        } else {
          if (viewModel.isUpdate) {
            Navigator.pop(context, true);
          }
          return true;
        }
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
        floatingActionButton: _saveFloatingActionButton(context),
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
          _medicineViewArea(context),
          SizedBox(height: 16.0),
          _conditionViewArea(context),
          SizedBox(height: 16.0),
          _sideAttributesView(context),
          SizedBox(height: 16.0),
          _memoView(context),
          SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _mealViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Column(
      children: [
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
              const SizedBox(width: 4),
              MealCard(
                type: MealType.lunch,
                detail: viewModel.lunch,
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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _medicineViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isDarkMode = Provider.of<AppSettings>(context).isDarkMode;
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
            Divider(),
            MedicineSelectChips(
              selectIds: viewModel.selectMedicineIds,
              allMedicines: viewModel.allMedicines,
              onChange: (Set<int> ids) => viewModel.changeSelectedMedicine(ids),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conditionViewArea(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    final isDarkMode = Provider.of<AppSettings>(context).isDarkMode;
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
            Divider(),
            ConditionSelectChips(
              selectIds: viewModel.selectConditionIds,
              allConditions: viewModel.allConditions,
              onChange: (Set<int> ids) => viewModel.changeSelectedCondition(ids),
            ),
            SizedBox(height: 8.0),
            MultiLineTextField(
              label: AppStrings.recordConditionMemoTitle,
              initValue: viewModel.conditionMemo,
              limitLine: 5,
              hintText: AppStrings.recordConditionMemoHint,
              onChanged: viewModel.inputConditionMemo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sideAttributesView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _walkingView(context),
      ],
    );
  }

  Widget _walkingView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          margin: EdgeInsets.only(top: 24.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 1),
            ],
          ),
          child: Row(
            children: [
              Text(AppStrings.recordWalkingLabel),
              Checkbox(
                value: viewModel.isWalking,
                onChanged: (bool? isCheck) => viewModel.inputIsWalking(isCheck),
              ),
            ],
          ),
        ),
        Positioned(
          left: 8.0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.directions_walk_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _memoView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiLineTextField(
          label: AppStrings.recordMemoTitle,
          initValue: viewModel.memo,
          limitLine: 5,
          hintText: AppStrings.recordMemoHint,
          onChanged: viewModel.inputMemo,
        ),
      ),
    );
  }

  Widget _saveFloatingActionButton(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return FloatingActionButton(
      onPressed: () async {
        // キーボードが出ている場合は閉じる
        FocusScope.of(context).unfocus();
        bool? isSuccess = await AppProgressDialog(execute: viewModel.save).show(context);
        if (isSuccess) {
          viewModel.isSuccessSaved();
        }
      },
      child: const Icon(Icons.save),
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
