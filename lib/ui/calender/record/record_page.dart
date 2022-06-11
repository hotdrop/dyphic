import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/widget/app_event_radio_group.dart';
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
class RecordPage extends ConsumerWidget {
  const RecordPage(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void>.delayed(Duration.zero).then((_) {
      ref.read(recordViewModelProvider).init(record);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(AppStrings.recordPageTitleDateFormat).format(record.date)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: _ViewBody(record),
        ),
      ),
    );
  }
}

class _ViewBody extends ConsumerStatefulWidget {
  const _ViewBody(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewBodyState();
}

class __ViewBodyState extends ConsumerState<_ViewBody> {
  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      ref.read(scrollPositionStateProvider.notifier).state = _controller.position.pixels;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(Duration.zero).then((_) {
      if (_controller.hasClients) {
        final position = ref.read(scrollPositionStateProvider);
        _controller.jumpTo(position);
      }
    });

    return ListView(
      controller: _controller,
      children: <Widget>[
        _ViewMealArea(id: widget.record.id),
        _ViewTemperature(id: widget.record.id),
        _ViewCondition(id: widget.record.id),
        const SizedBox(height: 8),
        _ViewMedicine(id: widget.record.id),
        const SizedBox(height: 8),
        _ViewMemo(id: widget.record.id),
        const SizedBox(height: 8),
        _ViewEvent(id: widget.record.id),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ViewMealArea extends StatelessWidget {
  const _ViewMealArea({Key? key, required this.id}) : super(key: key);

  final int id;

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
              _ViewMealMorning(id: id),
              const SizedBox(width: 4),
              _ViewMealLunch(id: id),
              const SizedBox(width: 4),
              _ViewMealDinner(id: id),
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
class _ViewMealMorning extends ConsumerWidget {
  const _ViewMealMorning({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.morning(
      detail: ref.watch(breakfastStateProvider) ?? '',
      onSubmitted: (String v) async {
        await ref.read(recordViewModelProvider).inputBreakfast(id: id, newVal: v);
      },
    );
  }
}

///
/// 昼食
///
class _ViewMealLunch extends ConsumerWidget {
  const _ViewMealLunch({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.lunch(
      detail: ref.watch(lunchStateProvider) ?? '',
      onSubmitted: (String v) async {
        await ref.read(recordViewModelProvider).inputLunch(id: id, newVal: v);
      },
    );
  }
}

///
/// 夕食
///
class _ViewMealDinner extends ConsumerWidget {
  const _ViewMealDinner({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.dinner(
      detail: ref.watch(dinnerStateProvider) ?? '',
      onSubmitted: (String v) async {
        await ref.read(recordViewModelProvider).inputDinner(id: id, newVal: v);
      },
    );
  }
}

///
/// 朝の体温
/// 夜の体温はいらないとのことで削除
///
class _ViewTemperature extends ConsumerWidget {
  const _ViewTemperature({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TemperatureView.morning(
            temperature: ref.watch(temperatureStateProvider),
            onSubmitted: (double v) async {
              await ref.read(recordViewModelProvider).inputMorningTemperature(id: id, newVal: v);
            },
          ),
        ],
      ),
    );
  }
}

///
/// 体調のView
///
class _ViewCondition extends ConsumerWidget {
  const _ViewCondition({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _ContentsTitle(title: AppStrings.recordConditionTitle, appIcon: AppIcon.condition()),
            const Divider(),
            ConditionSelectChips(
              selectIds: ref.watch(conditionStateProvider).selectIds,
              onChange: (Set<int> ids) {
                ref.watch(conditionStateProvider.notifier).changeSelectIds(ids);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppCheckBox.walking(
                  initValue: ref.watch(conditionStateProvider).isWalking,
                  onChanged: (bool newVal) {
                    ref.read(conditionStateProvider.notifier).inputIsWalk(newVal);
                  },
                ),
                AppCheckBox.toilet(
                  initValue: ref.watch(conditionStateProvider).isToilet,
                  onChanged: (bool newVal) {
                    ref.read(conditionStateProvider.notifier).inputIsToilet(newVal);
                  },
                ),
              ],
            ),
            MultiLineTextField(
              label: AppStrings.recordConditionMemoTitle,
              initValue: ref.watch(conditionStateProvider).conditionMemo,
              limitLine: 10,
              hintText: AppStrings.recordConditionMemoHint,
              onChanged: (String newVal) {
                ref.read(conditionStateProvider.notifier).inputMemo(newVal);
              },
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _save(context, ref) : null,
              child: const Text(AppStrings.recordConditionSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(conditionStateProvider.notifier).save(id);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

///
/// お薬の選択View
///
class _ViewMedicine extends ConsumerWidget {
  const _ViewMedicine({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1.0,
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
              selectIds: ref.watch(medicineIdsStateProvider),
              onChanged: (Set<int> ids) {
                ref.watch(medicineIdsStateProvider.notifier).changeSelectIds(ids);
              },
            ),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn
                  ? () async {
                      await _processSaveMedicine(context, ref);
                    }
                  : null,
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
      execute: () async {
        await ref.read(medicineIdsStateProvider.notifier).save(id);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

///
/// メモ
///
class _ViewMemo extends ConsumerWidget {
  const _ViewMemo({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MultiLineTextField(
              label: AppStrings.recordMemoTitle,
              initValue: ref.watch(memoStateProvider),
              limitLine: 10,
              hintText: AppStrings.recordMemoHint,
              onChanged: (String input) {
                ref.watch(memoStateProvider.notifier).state = input;
              },
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _saveMemo(context, ref) : null,
              child: const Text(AppStrings.recordMemoSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMemo(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveMemo(id: id);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

///
/// イベント情報
///
class _ViewEvent extends ConsumerWidget {
  const _ViewEvent({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            EventRadioGroup(
              selectValue: ref.watch(eventStateProvider).eventType,
              onSelected: (EventType? newVal) {
                if (newVal != null) {
                  ref.watch(eventStateProvider.notifier).inputType(newVal);
                }
              },
            ),
            AppTextField(
              label: AppStrings.recordEventLabel,
              initValue: ref.watch(eventStateProvider).eventName,
              onChanged: (String newVal) {
                ref.watch(eventStateProvider.notifier).inputName(newVal);
              },
            ),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _saveEvent(context, ref) : null,
              child: const Text(AppStrings.recordEventSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvent(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(eventStateProvider.notifier).save(id);
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
