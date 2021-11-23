import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/widget/app_check_box.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:dyphic/ui/widget/meal_card.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/temperature_view.dart';

class RecordPage extends ConsumerStatefulWidget {
  const RecordPage(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  ConsumerState<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends ConsumerState<RecordPage> {
  String _inputBreakfast = '';
  String _inputLunch = '';
  String _inputDinner = '';

  double _inputMorningTemperature = 0;
  double _inputNightTemperature = 0;

  Set<int> _inputSelectConditionIds = {};
  bool _inputIsWalking = false;
  bool _inputIsToilet = false;
  String _inputConditionMemo = '';

  Set<int> _inputSelectMedicineIds = {};

  String _inputMemo = '';

  @override
  void initState() {
    super.initState();
    _inputBreakfast = widget.record.breakfast ?? '';
    _inputLunch = widget.record.lunch ?? '';
    _inputDinner = widget.record.dinner ?? '';

    _inputMorningTemperature = widget.record.morningTemperature ?? 0;
    _inputNightTemperature = widget.record.nightTemperature ?? 0;

    _inputSelectConditionIds = widget.record.conditions.map((e) => e.id).toSet();
    _inputIsWalking = widget.record.isWalking;
    _inputIsToilet = widget.record.isToilet;
    _inputConditionMemo = widget.record.conditionMemo ?? '';

    _inputSelectMedicineIds = widget.record.medicines.map((e) => e.id).toSet();

    _inputMemo = widget.record.memo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(AppStrings.recordPageTitleDateFormat).format(widget.record.date)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView(
            children: <Widget>[
              _viewMealArea(),
              _viewTemperatureArea(),
              _viewConditionArea(),
              const SizedBox(height: 16.0),
              _viewMedicineArea(),
              const SizedBox(height: 16.0),
              _viewMemo(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewMealArea() {
    return Column(
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _viewMorningCard(),
              const SizedBox(width: 4),
              _viewLunchCard(),
              const SizedBox(width: 4),
              _viewDinnerCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _viewMorningCard() {
    return MealCard.morning(
      detail: _inputBreakfast,
      onSubmitted: (String? v) async {
        if (v != null) {
          await ref.read(recordViewModelProvider).inputBreakfast(id: widget.record.id, newVal: v);
          setState(() {
            _inputBreakfast = v;
          });
        }
      },
    );
  }

  Widget _viewLunchCard() {
    return MealCard.lunch(
      detail: _inputLunch,
      onSubmitted: (String? v) async {
        if (v != null) {
          await ref.read(recordViewModelProvider).inputLunch(id: widget.record.id, newVal: v);
          setState(() {
            _inputLunch = v;
          });
        }
      },
    );
  }

  Widget _viewDinnerCard() {
    return MealCard.dinner(
      detail: _inputDinner,
      onSubmitted: (String? v) {
        if (v != null) {
          ref.read(recordViewModelProvider).inputDinner(id: widget.record.id, newVal: v);
          setState(() {
            _inputDinner = v;
          });
        }
      },
    );
  }

  Widget _viewTemperatureArea() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: _inputMorningTemperature,
            onSubmitted: (double? v) {
              if (v != null) {
                ref.read(recordViewModelProvider).inputMorningTemperature(id: widget.record.id, newVal: v);
                setState(() {
                  _inputMorningTemperature = v;
                });
              }
            },
          ),
          TemperatureView.night(
            temperature: _inputNightTemperature,
            onSubmitted: (double? v) async {
              if (v != null) {
                await ref.read(recordViewModelProvider).inputNightTemperature(id: widget.record.id, newVal: v);
                setState(() {
                  _inputNightTemperature = v;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _viewConditionArea() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _ContentsTitle(
              title: AppStrings.recordConditionTitle,
              appIcon: AppIcon.condition(),
            ),
            const Divider(),
            _viewConditionSelectChips(),
            const Divider(),
            _viewConditionCheckBoxes(),
            _viewConditionMemo(),
            const SizedBox(height: 8.0),
            _viewConditionSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _viewConditionSelectChips() {
    return ConditionSelectChips(
      selectIds: _inputSelectConditionIds,
      onChange: (Set<int> ids) {
        AppLogger.d('選択している症状は $ids です');
        setState(() {
          _inputSelectConditionIds = ids;
        });
      },
    );
  }

  Widget _viewConditionCheckBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: _inputIsWalking,
          onChanged: (bool? isCheck) {
            AppLogger.d('歩いたチェック: $isCheck');
            setState(() {
              _inputIsWalking = isCheck ?? false;
            });
          },
        ),
        AppCheckBox.toilet(
          initValue: _inputIsToilet,
          onChanged: (bool? isCheck) {
            AppLogger.d('トイレチェック: $isCheck');
            setState(() {
              _inputIsToilet = isCheck ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _viewConditionMemo() {
    return MultiLineTextField(
      label: AppStrings.recordConditionMemoTitle,
      initValue: _inputConditionMemo,
      limitLine: 10,
      hintText: AppStrings.recordConditionMemoHint,
      onChanged: (String? input) {
        if (input != null) {
          setState(() {
            _inputConditionMemo = input;
          });
        }
      },
    );
  }

  Widget _viewConditionSaveButton(BuildContext context) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveCondition(context) : null,
      child: const Text(AppStrings.recordConditionSaveButton),
    );
  }

  Future<void> _processSaveCondition(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveCondition(
              id: widget.record.id,
              conditionIds: _inputSelectConditionIds,
              isWalking: _inputIsWalking,
              isToilet: _inputIsToilet,
              memo: _inputConditionMemo,
            );
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }

  Widget _viewMedicineArea() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _ContentsTitle(
              title: AppStrings.recordMedicalTitle,
              appIcon: AppIcon.medicine(),
            ),
            const Divider(),
            _viewMedicineSelectChips(),
            _viewMedicineSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _viewMedicineSelectChips() {
    return MedicineSelectChips(
      selectIds: _inputSelectMedicineIds,
      onChanged: (Set<int> ids) {
        AppLogger.d('選択しているお薬は $ids です');
        setState(() => _inputSelectMedicineIds = ids);
      },
    );
  }

  Widget _viewMedicineSaveButton(BuildContext context) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveMedicine(context) : null,
      child: const Text(AppStrings.recordMedicineSaveButton),
    );
  }

  Future<void> _processSaveMedicine(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveMedicine(
              id: widget.record.id,
              medicineIds: _inputSelectMedicineIds,
            );
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }

  Widget _viewMemo(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MultiLineTextField(
              label: AppStrings.recordMemoTitle,
              initValue: _inputMemo,
              limitLine: 10,
              hintText: AppStrings.recordMemoHint,
              onChanged: (String? input) {
                if (input != null) {
                  setState(() => _inputMemo = input);
                }
              },
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _saveMemo(context) : null,
              child: const Text(AppStrings.recordMemoSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMemo(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveMemo(id: widget.record.id, memo: _inputMemo);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

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
