import 'package:dyphic/model/record.dart';
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
  const RecordPage._(this._record);

  static Future<bool> start(BuildContext context, Record record) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => RecordPage._(record)),
        ) ??
        false;
  }

  final Record _record;

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
      ref.read(recordViewModelProvider).init(_record.id);
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
    return DateFormat(AppStrings.recordPageTitleDateFormat).format(_record.date);
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    if (isSignIn) {
      return WillPopScope(
        onWillPop: () async {
          final isUpdate = ref.read(recordViewModelProvider).isUpdate();
          if (isUpdate) {
            ref.read(recordViewModelProvider).update();
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
              _ConditionArea(_record),
              const SizedBox(height: 16.0),
              _MedicineArea(_record),
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
                detail: _record.breakfast ?? '',
                onSubmitted: (String? v) => ref.read(recordViewModelProvider).inputBreakfast(v),
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                detail: _record.lunch ?? '',
                onSubmitted: (String? v) => ref.read(recordViewModelProvider).inputLunch(v),
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                detail: _record.dinner ?? '',
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
            temperature: _record.morningTemperature ?? 0,
            onSubmitted: (double? newValue) {
              if (newValue != null) {
                ref.read(recordViewModelProvider).inputMorningTemperature(newValue);
              }
            },
          ),
          TemperatureView.night(
            temperature: _record.nightTemperature ?? 0,
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
              initValue: _record.memo,
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
  const _ConditionArea(this._record);

  final Record _record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _viewTitle(),
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

  Widget _viewTitle() {
    return _ContentsTitle(
      title: AppStrings.recordConditionTitle,
      appIcon: AppIcon.condition(),
    );
  }

  Widget _viewSelectChips(WidgetRef ref) {
    return ConditionSelectChips(
      selectIds: _record.conditions.map((e) => e.id).toSet(),
      onChange: (Set<int> ids) => ref.read(recordViewModelProvider).changeSelectedCondition(ids),
    );
  }

  Widget _viewCheckBoxes(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: _record.isWalking,
          onChanged: (bool? isCheck) => ref.read(recordViewModelProvider).inputIsWalking(isCheck),
        ),
        AppCheckBox.toilet(
          initValue: _record.isToilet,
          onChanged: (bool? isCheck) => ref.read(recordViewModelProvider).inputIsToilet(isCheck),
        ),
      ],
    );
  }

  Widget _viewMemo(WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.recordConditionMemoTitle,
      initValue: _record.conditionMemo,
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
  const _MedicineArea(this._record);

  final Record _record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _viewTitle(),
            const Divider(),
            _viewSelectChips(ref),
            _viewSaveButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle() {
    return _ContentsTitle(
      title: AppStrings.recordMedicalTitle,
      appIcon: AppIcon.medicine(),
    );
  }

  Widget _viewSelectChips(WidgetRef ref) {
    return MedicineSelectChips(
      selectIds: _record.medicines.map((e) => e.id).toSet(),
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
