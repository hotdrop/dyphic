import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dyphic/model/app_settings.dart';
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
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
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
              const _ConditionArea(),
              const SizedBox(height: 16.0),
              const _MedicineArea(),
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
                onSubmitted: (String? v) => ref.read(recordViewModelProvider).inputBreakfast(v),
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                detail: ref.watch(recordViewModelProvider).lunch,
                onSubmitted: (String? v) => ref.read(recordViewModelProvider).inputLunch(v),
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                detail: ref.watch(recordViewModelProvider).dinner,
                onSubmitted: (String? v) => ref.read(recordViewModelProvider).inputDinner(v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _temperatureViewArea(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: ref.watch(recordViewModelProvider).morningTemperature,
            onSubmitted: (double? newValue) {
              if (newValue != null) {
                ref.read(recordViewModelProvider).inputMorningTemperature(newValue);
              }
            },
          ),
          TemperatureView.night(
            temperature: ref.watch(recordViewModelProvider).nightTemperature,
            onSubmitted: (double? newValue) {
              if (newValue != null) {
                ref.read(recordViewModelProvider).inputNightTemperature(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _memoView(BuildContext context, WidgetRef ref) {
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
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _processSaveMemo(context, ref) : null,
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
}

///
/// 体調情報の編集エリア
///
class _ConditionArea extends ConsumerWidget {
  const _ConditionArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _viewTitle(ref),
            const Divider(),
            _viewSelectChips(ref),
            const Divider(),
            _viewCheckBoxes(ref),
            _viewMemo(ref),
            const SizedBox(height: 8.0),
            _viewSaveButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle(WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return _ContentsTitle(
      title: AppStrings.recordConditionTitle,
      appIcon: AppIcon.condition(isDarkMode),
    );
  }

  Widget _viewSelectChips(WidgetRef ref) {
    return ConditionSelectChips(
      selectIds: ref.read(recordViewModelProvider).selectConditionIds,
      onChange: (Set<int> ids) => ref.read(recordViewModelProvider).changeSelectedCondition(ids),
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

  Widget _viewMemo(WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.recordConditionMemoTitle,
      initValue: ref.read(recordViewModelProvider).conditionMemo,
      limitLine: 10,
      hintText: AppStrings.recordConditionMemoHint,
      onChanged: ref.read(recordViewModelProvider).inputConditionMemo,
    );
  }

  Widget _viewSaveButton(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveCondition(context, ref) : null,
      child: const Text(AppStrings.recordConditionSaveButton),
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
}

///
/// お薬情報の編集エリア
///
class _MedicineArea extends ConsumerWidget {
  const _MedicineArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _viewTitle(ref),
            const Divider(),
            _viewSelectChips(ref),
            _viewSaveButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle(WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return _ContentsTitle(
      title: AppStrings.recordMedicalTitle,
      appIcon: AppIcon.medicine(isDarkMode),
    );
  }

  Widget _viewSelectChips(WidgetRef ref) {
    return MedicineSelectChips(
      selectIds: ref.watch(recordViewModelProvider).selectMedicineIds,
      onChanged: (Set<int> ids) => ref.read(recordViewModelProvider).changeSelectedMedicine(ids),
    );
  }

  Widget _viewSaveButton(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveMedicine(context, ref) : null,
      child: const Text(AppStrings.recordMedicineSaveButton),
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
}

///
/// 各エリアのタイトル
///
class _ContentsTitle extends StatelessWidget {
  const _ContentsTitle({
    Key? key,
    required this.title,
    required this.appIcon,
  }) : super(key: key);

  final String title;
  final AppIcon appIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        appIcon,
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
