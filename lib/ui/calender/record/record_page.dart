import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/app_check_box.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:dyphic/ui/widget/meal_card.dart';
import 'package:dyphic/ui/widget/temperature_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage._(this._date);

  static Future<bool> start(BuildContext context, DateTime date) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => RecordPage._(date)),
        ) ??
        false;
  }

  final DateTime _date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(recordViewModelProvider).uiState;
    return uiState.when(
      loading: (err) => _onLoading(context, ref, err),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, WidgetRef ref, String? errorMsg) {
    Future.delayed(Duration.zero).then((_) async {
      ref.read(recordViewModelProvider).init(_date);
      if (errorMsg != null) {
        await AppDialog.onlyOk(message: errorMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle()),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String _pageTitle() {
    return DateFormat(AppStrings.recordPageTitleDateFormat).format(_date);
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(recordViewModelProvider).isSignIn;
    if (isSignIn) {
      return WillPopScope(
        onWillPop: () async {
          final isUpdate = ref.watch(recordViewModelProvider).isUpdate;
          if (isUpdate) {
            Navigator.pop(context, true);
          }
          return true;
        },
        child: _viewBody(context, ref),
      );
    } else {
      return _viewBody(context, ref);
    }
  }

  Widget _viewBody(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageTitle())),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView(
            children: <Widget>[
              _mealViewArea(context, ref),
              _temperatureViewArea(ref),
              _conditionViewArea(context, ref),
              const SizedBox(height: 16.0),
              _medicineViewArea(context, ref),
              const SizedBox(height: 16.0),
              _memoView(context, ref),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealViewArea(BuildContext context, WidgetRef ref) {
    final isEditable = ref.watch(recordViewModelProvider).isSignIn;
    return Column(
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard.morning(
                detail: ref.watch(recordViewModelProvider).breakfast,
                isEditable: isEditable,
                onTap: (String? newVal) {
                  if (newVal != null) {
                    ref.read(recordViewModelProvider).inputBreakfast(newVal);
                  }
                },
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                detail: ref.watch(recordViewModelProvider).lunch,
                isEditable: isEditable,
                onTap: (String? newVal) {
                  if (newVal != null) {
                    ref.read(recordViewModelProvider).inputLunch(newVal);
                  }
                },
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                detail: ref.watch(recordViewModelProvider).dinner,
                isEditable: isEditable,
                onEdit: (String? newVal) {
                  if (newVal != null) {
                    ref.read(recordViewModelProvider).inputDinner(newVal);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _temperatureViewArea(WidgetRef ref) {
    final isEditable = ref.read(recordViewModelProvider).isSignIn;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: ref.watch(recordViewModelProvider).morningTemperature,
            isEditable: isEditable,
            onEditValue: (double? newValue) {
              if (newValue != null) {
                ref.read(recordViewModelProvider).inputMorningTemperature(newValue);
              }
            },
          ),
          TemperatureView.night(
            temperature: ref.watch(recordViewModelProvider).nightTemperature,
            isEditable: isEditable,
            onEditValue: (double? newValue) {
              if (newValue != null) {
                ref.read(recordViewModelProvider).inputNightTemperature(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _medicineViewArea(BuildContext context, WidgetRef ref) {
    // TODO ここwidgetに切り出した方がいいのでは
    final isDarkMode = ref.watch(recordViewModelProvider).isDarkMode;
    final isSignIn = ref.watch(recordViewModelProvider).isSignIn;
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
              selectIds: ref.read(recordViewModelProvider).selectMedicineIds,
              allMedicines: ref.read(recordViewModelProvider).allMedicines,
              onChange: (Set<int> ids) => ref.read(recordViewModelProvider).changeSelectedMedicine(ids),
            ),
            OutlinedButton(
              onPressed: isSignIn ? () async => await _processSaveMedicine(context, ref) : null,
              child: const Text(AppStrings.recordMedicineSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processSaveMedicine(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(recordViewModelProvider).saveMedicine,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }

  Widget _conditionViewArea(BuildContext context, WidgetRef ref) {
    // TODO ここwidgetに切り出した方がいいのでは
    final isDarkMode = ref.watch(recordViewModelProvider).isDarkMode;
    final isSignIn = ref.watch(recordViewModelProvider).isSignIn;
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
              selectIds: ref.read(recordViewModelProvider).selectConditionIds,
              allConditions: ref.read(recordViewModelProvider).allConditions,
              onChange: (Set<int> ids) => ref.read(recordViewModelProvider).changeSelectedCondition(ids),
            ),
            const Divider(),
            _viewCheckBoxes(ref),
            MultiLineTextField(
              label: AppStrings.recordConditionMemoTitle,
              initValue: ref.read(recordViewModelProvider).conditionMemo,
              limitLine: 10,
              hintText: AppStrings.recordConditionMemoHint,
              onChanged: ref.read(recordViewModelProvider).inputConditionMemo,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: isSignIn ? () async => await _processSaveCondition(context, ref) : null,
              child: const Text(AppStrings.recordConditionSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processSaveCondition(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(recordViewModelProvider).saveCondition,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }

  Widget _viewCheckBoxes(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: ref.watch(recordViewModelProvider).isWalking,
          onChanged: (bool? isCheck) => ref.read(recordViewModelProvider).inputIsWalking(isCheck),
        ),
        AppCheckBox.toilet(
          initValue: ref.watch(recordViewModelProvider).isToilet,
          onChanged: (bool? isCheck) => ref.read(recordViewModelProvider).inputIsToilet(isCheck),
        ),
      ],
    );
  }

  Widget _memoView(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(recordViewModelProvider).isSignIn;
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MultiLineTextField(
              label: AppStrings.recordMemoTitle,
              initValue: ref.watch(recordViewModelProvider).memo,
              limitLine: 10,
              hintText: AppStrings.recordMemoHint,
              onChanged: ref.read(recordViewModelProvider).inputMemo,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: isSignIn ? () async => await _processSaveMemo(context, ref) : null,
              child: const Text(AppStrings.recordMemoSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processSaveMemo(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(recordViewModelProvider).saveMemo,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
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
