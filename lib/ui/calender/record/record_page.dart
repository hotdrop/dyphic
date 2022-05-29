import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
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

///
/// このページはRecordsPageViewから構築されるのでスワイプでページ移動可能になっている。
/// なるべくスワイプでのページ移動をスムースにするためこのような作りにしている。
/// （途中、StateProviderを使った方法で試したがどうしてもスムースにページ移動できないのでやめた
///
class RecordPage extends StatelessWidget {
  const RecordPage(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(AppStrings.recordPageTitleDateFormat).format(record.date)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView(
            children: <Widget>[
              _ViewMealArea(record: record),
              _ViewTemperature(
                recordId: record.id,
                morningTemperature: record.morningTemperature,
                nightTemperature: record.nightTemperature,
              ),
              _ViewCondition(
                recordId: record.id,
                conditions: record.conditions,
                isWalking: record.isWalking,
                isToilet: record.isToilet,
                conditionMemo: record.memo,
              ),
              const SizedBox(height: 16.0),
              _ViewMedicine(recordId: record.id, medicines: record.medicines),
              const SizedBox(height: 16.0),
              _ViewMemo(recordId: record.id, memo: record.memo),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewMealArea extends StatelessWidget {
  const _ViewMealArea({Key? key, required this.record}) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _ViewMealMorning(recordId: record.id, breakfast: record.breakfast),
              const SizedBox(width: 4),
              _ViewMealLunch(recordId: record.id, lunch: record.lunch),
              const SizedBox(width: 4),
              _ViewMealDinner(recordId: record.id, dinner: record.dinner),
            ],
          ),
        ),
      ],
    );
  }
}

///
/// 朝食
///
class _ViewMealMorning extends ConsumerStatefulWidget {
  const _ViewMealMorning({Key? key, required this.recordId, required this.breakfast}) : super(key: key);

  final int recordId;
  final String? breakfast;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewMealMorningState();
}

class __ViewMealMorningState extends ConsumerState<_ViewMealMorning> {
  String _inputBreakfast = '';

  @override
  void initState() {
    _inputBreakfast = widget.breakfast ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MealCard.morning(
      detail: _inputBreakfast,
      onSubmitted: _onSubmittetd,
    );
  }

  Future<void> _onSubmittetd(String? v) async {
    if (v != null) {
      await ref.read(recordViewModelProvider).inputBreakfast(id: widget.recordId, newVal: v);
      setState(() {
        _inputBreakfast = v;
      });
    }
  }
}

///
/// 昼食
///
class _ViewMealLunch extends ConsumerStatefulWidget {
  const _ViewMealLunch({Key? key, required this.recordId, required this.lunch}) : super(key: key);

  final int recordId;
  final String? lunch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewLunchMealState();
}

class __ViewLunchMealState extends ConsumerState<_ViewMealLunch> {
  late String _inputLunch;

  @override
  void initState() {
    _inputLunch = widget.lunch ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MealCard.lunch(
      detail: _inputLunch,
      onSubmitted: _onSubmittetd,
    );
  }

  Future<void> _onSubmittetd(String? v) async {
    if (v != null) {
      await ref.read(recordViewModelProvider).inputLunch(id: widget.recordId, newVal: v);
      setState(() {
        _inputLunch = v;
      });
    }
  }
}

///
/// 夕食
///
class _ViewMealDinner extends ConsumerStatefulWidget {
  const _ViewMealDinner({Key? key, required this.recordId, required this.dinner}) : super(key: key);

  final int recordId;
  final String? dinner;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewMealDinnerState();
}

class __ViewMealDinnerState extends ConsumerState<_ViewMealDinner> {
  late String _inputDinner;

  @override
  void initState() {
    _inputDinner = widget.dinner ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MealCard.dinner(
      detail: _inputDinner,
      onSubmitted: _onSubmittetd,
    );
  }

  Future<void> _onSubmittetd(String? v) async {
    if (v != null) {
      await ref.read(recordViewModelProvider).inputDinner(id: widget.recordId, newVal: v);
      setState(() {
        _inputDinner = v;
      });
    }
  }
}

///
/// 朝の体温と夜の体温
///
class _ViewTemperature extends ConsumerStatefulWidget {
  const _ViewTemperature({
    Key? key,
    required this.recordId,
    required this.morningTemperature,
    required this.nightTemperature,
  }) : super(key: key);

  final int recordId;
  final double? morningTemperature;
  final double? nightTemperature;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewTemperatureState();
}

class __ViewTemperatureState extends ConsumerState<_ViewTemperature> {
  late double _inputMorningTemperature;
  late double _inputNightTemperature;

  @override
  void initState() {
    _inputMorningTemperature = widget.morningTemperature ?? 0;
    _inputNightTemperature = widget.nightTemperature ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: _inputMorningTemperature,
            onSubmitted: _onSubmittedMorning,
          ),
          TemperatureView.night(
            temperature: _inputNightTemperature,
            onSubmitted: _onSubmittedNight,
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmittedMorning(double? v) async {
    if (v != null) {
      await ref.read(recordViewModelProvider).inputMorningTemperature(id: widget.recordId, newVal: v);
      setState(() => _inputMorningTemperature = v);
    }
  }

  Future<void> _onSubmittedNight(double? v) async {
    if (v != null) {
      await ref.read(recordViewModelProvider).inputNightTemperature(id: widget.recordId, newVal: v);
      setState(() => _inputNightTemperature = v);
    }
  }
}

///
/// 体調のView
///
class _ViewCondition extends ConsumerStatefulWidget {
  const _ViewCondition({
    Key? key,
    required this.recordId,
    required this.conditions,
    required this.isWalking,
    required this.isToilet,
    required this.conditionMemo,
  }) : super(key: key);

  final int recordId;
  final List<Condition> conditions;
  final bool isWalking;
  final bool isToilet;
  final String? conditionMemo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewConditionState();
}

class __ViewConditionState extends ConsumerState<_ViewCondition> {
  late Set<int> _inputSelectConditionIds;
  late bool _inputIsWalking;
  late bool _inputIsToilet;
  late String _inputConditionMemo;

  @override
  void initState() {
    _inputSelectConditionIds = widget.conditions.map((e) => e.id).toSet();
    _inputIsWalking = widget.isWalking;
    _inputIsToilet = widget.isToilet;
    _inputConditionMemo = widget.conditionMemo ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _ContentsTitle(title: AppStrings.recordConditionTitle, appIcon: AppIcon.condition()),
            const Divider(),
            ConditionSelectChips(selectIds: _inputSelectConditionIds, onChange: _onChangeSelectConditionChip),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppCheckBox.walking(initValue: _inputIsWalking, onChanged: _onChangeCheckWalking),
                AppCheckBox.toilet(initValue: _inputIsToilet, onChanged: _onChangeCheckToilet),
              ],
            ),
            MultiLineTextField(
              label: AppStrings.recordConditionMemoTitle,
              initValue: _inputConditionMemo,
              limitLine: 10,
              hintText: AppStrings.recordConditionMemoHint,
              onChanged: _onChangeConditionMemo,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _save(context) : null,
              child: const Text(AppStrings.recordConditionSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeSelectConditionChip(Set<int> ids) {
    setState(() {
      _inputSelectConditionIds = ids;
    });
  }

  void _onChangeCheckWalking(bool? isCheck) {
    if (isCheck != null) {
      setState(() {
        _inputIsWalking = isCheck;
      });
    }
  }

  void _onChangeCheckToilet(bool? isCheck) {
    if (isCheck != null) {
      setState(() {
        _inputIsToilet = isCheck;
      });
    }
  }

  void _onChangeConditionMemo(String? input) {
    if (input != null) {
      setState(() {
        _inputConditionMemo = input;
      });
    }
  }

  Future<void> _save(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveCondition(
              id: widget.recordId,
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
}

///
/// お薬の選択View
///
class _ViewMedicine extends ConsumerStatefulWidget {
  const _ViewMedicine({Key? key, required this.recordId, required this.medicines}) : super(key: key);

  final int recordId;
  final List<Medicine> medicines;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewMedicineState();
}

class __ViewMedicineState extends ConsumerState<_ViewMedicine> {
  late Set<int> _inputSelectMedicineIds;

  @override
  void initState() {
    _inputSelectMedicineIds = widget.medicines.map((e) => e.id).toSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            MedicineSelectChips(
              selectIds: _inputSelectMedicineIds,
              onChanged: (Set<int> ids) {
                AppLogger.d('選択しているお薬は $ids です');
                setState(() => _inputSelectMedicineIds = ids);
              },
            ),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn
                  ? () async {
                      await _processSaveMedicine(context);
                    }
                  : null,
              child: const Text(AppStrings.recordMedicineSaveButton),
            ),
          ],
        ),
      ),
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
              id: widget.recordId,
              medicineIds: _inputSelectMedicineIds,
            );
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

///
/// メモ
///
class _ViewMemo extends ConsumerStatefulWidget {
  const _ViewMemo({Key? key, required this.recordId, required this.memo}) : super(key: key);

  final int recordId;
  final String? memo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewMemoState();
}

class __ViewMemoState extends ConsumerState<_ViewMemo> {
  late String _inputMemo;

  @override
  void initState() {
    _inputMemo = widget.memo ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        await ref.read(recordViewModelProvider).saveMemo(id: widget.recordId, memo: _inputMemo);
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
