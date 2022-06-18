import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/ui/calender/record/widgets/meal_widget.dart';
import 'package:dyphic/ui/calender/record/widgets/morning_temperature_widget.dart';
import 'package:dyphic/ui/widget/app_check_box.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_event_radio_group.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';

///
/// このページはRecordsPageViewから構築されるのでスワイプでページ移動可能になっている。
/// なるべくスワイプでのページ移動をスムースにするためこのような作りにしている。
/// （途中、StateProviderを使った方法で試したがどうしてもスムースにページ移動できないのでやめた
///
class RecordPage extends ConsumerWidget {
  const RecordPage(this.recordId, {Key? key}) : super(key: key);

  final int recordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordDate = DyphicID.idToDate(recordId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat(AppStrings.recordPageTitleDateFormat).format(recordDate),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder(
          future: ref.read(recordViewModelProvider).find(recordId),
          builder: (BuildContext context, AsyncSnapshot<Record> snapshot) {
            if (snapshot.hasData) {
              return _ViewBody(snapshot.data!);
            }
            return const _ViewLoading();
          },
        ),
      ),
    );
  }
}

class _ViewLoading extends ConsumerWidget {
  const _ViewLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ViewBody extends ConsumerStatefulWidget {
  const _ViewBody(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewBodyState();
}

class _ViewBodyState extends ConsumerState<_ViewBody> {
  final _controller = ScrollController();

  String _inputBreakfast = '';
  String _inputLunch = '';
  String _inputDinner = '';

  double _inputMorningTemperature = 0;

  Set<int> _inputSelectConditionIds = {};
  bool _inputIsWalking = false;
  bool _inputIsToilet = false;
  String _inputConditionMemo = '';

  Set<int> _inputSelectMedicineIds = {};

  String _inputMemo = '';
  EventType _inputEventType = EventType.none;
  String _inputEventName = '';

  @override
  void initState() {
    _inputBreakfast = widget.record.breakfast ?? '';
    _inputLunch = widget.record.lunch ?? '';
    _inputDinner = widget.record.dinner ?? '';

    _inputMorningTemperature = widget.record.morningTemperature ?? 0;

    _inputSelectConditionIds = widget.record.conditions.map((e) => e.id).toSet();
    _inputIsWalking = widget.record.isWalking;
    _inputIsToilet = widget.record.isToilet;
    _inputConditionMemo = widget.record.conditionMemo ?? '';

    _inputSelectMedicineIds = widget.record.medicines.map((e) => e.id).toSet();

    _inputMemo = widget.record.memo ?? '';

    _inputEventType = widget.record.eventType;
    _inputEventName = widget.record.eventName ?? '';

    _controller.addListener(() {
      ref.read(scrollPositionStateProvider.notifier).state = _controller.position.pixels;
    });

    Future<void>.delayed(Duration.zero).then((_) {
      if (_controller.hasClients) {
        final position = ref.read(scrollPositionStateProvider);
        _controller.jumpTo(position);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = ref.read(appSettingsProvider).isSignIn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView(
        controller: _controller,
        children: [
          // 朝食、昼食、夕食
          _ViewMealArea(
            children: [
              MealBreakfastWidget(currentValue: _inputBreakfast, onSubmitted: _processSaveBreakfast),
              const SizedBox(width: 4),
              MealLunchWidget(currentValue: _inputLunch, onSubmitted: _processSaveLunch),
              const SizedBox(width: 4),
              MealDinnerWidget(currentValue: _inputDinner, onSubmitted: _processSaveDinner),
            ],
          ),
          const SizedBox(height: 16),
          // 体温
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MorningTemperatureWidget(
                currentValue: _inputMorningTemperature,
                onSubmitted: _processSaveMorningTemperature,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 体調
          _ViewConditionArea(
            children: [
              _ContentsTitle(title: AppStrings.recordConditionTitle, appIcon: AppIcon.condition()),
              const Divider(),
              ConditionSelectChips(
                selectIds: _inputSelectConditionIds,
                onChange: (Set<int> ids) {
                  setState(() => _inputSelectConditionIds = ids);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppCheckBox.walking(
                    initValue: _inputIsWalking,
                    onChanged: (bool newVal) {
                      setState(() => _inputIsWalking = newVal);
                    },
                  ),
                  AppCheckBox.toilet(
                    initValue: _inputIsToilet,
                    onChanged: (bool newVal) {
                      setState(() => _inputIsToilet = newVal);
                    },
                  ),
                ],
              ),
              MultiLineTextField(
                label: AppStrings.recordConditionMemoTitle,
                initValue: _inputConditionMemo,
                limitLine: 10,
                hintText: AppStrings.recordConditionMemoHint,
                onChanged: (String newVal) {
                  setState(() => _inputConditionMemo = newVal);
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveCondition(context) : null,
                child: const Text(AppStrings.recordConditionSaveButton),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // お薬
          _ViewMedicineArea(
            children: [
              _ContentsTitle(title: AppStrings.recordMedicalTitle, appIcon: AppIcon.medicine()),
              const Divider(),
              MedicineSelectChips(
                selectIds: _inputSelectMedicineIds,
                onChanged: (Set<int> ids) {
                  setState(() => _inputSelectMedicineIds = ids);
                },
              ),
              OutlinedButton(
                onPressed: isSignIn ? () async => await _processSaveMedicine(context) : null,
                child: const Text(AppStrings.recordMedicineSaveButton),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // メモ
          _ViewMemoArea(
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
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveMemo(context) : null,
                child: const Text(AppStrings.recordMemoSaveButton),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // イベント
          _ViewEventArea(
            children: [
              EventRadioGroup(
                selectValue: _inputEventType,
                onSelected: (EventType? newVal) {
                  if (newVal != null) {
                    setState(() => _inputEventType = newVal);
                  }
                },
              ),
              AppTextField(
                label: AppStrings.recordEventLabel,
                initValue: _inputEventName,
                onChanged: (String newVal) {
                  setState(() => _inputEventName = newVal);
                },
              ),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveEvent(context) : null,
                child: const Text(AppStrings.recordEventSaveButton),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Future<void> _processSaveBreakfast(String newVal) async {
    if (ref.read(appSettingsProvider).isSignIn) {
      ref.read(recordViewModelProvider).inputBreakfast(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputBreakfast = newVal);
  }

  Future<void> _processSaveLunch(String newVal) async {
    if (ref.read(appSettingsProvider).isSignIn) {
      ref.read(recordViewModelProvider).inputLunch(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputLunch = newVal);
  }

  Future<void> _processSaveDinner(String newVal) async {
    if (ref.read(appSettingsProvider).isSignIn) {
      ref.read(recordViewModelProvider).inputDinner(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputDinner = newVal);
  }

  Future<void> _processSaveMorningTemperature(double? v) async {
    if (v != null && ref.read(appSettingsProvider).isSignIn) {
      ref.read(recordViewModelProvider).inputMorningTemperature(id: widget.record.id, newVal: v);
      setState(() {
        _inputMorningTemperature = v;
      });
    }
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

  Future<void> _processSaveMemo(BuildContext context) async {
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

  Future<void> _processSaveEvent(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveEvent(id: widget.record.id, eventType: _inputEventType, eventName: _inputEventName);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _ViewMealArea extends StatelessWidget {
  const _ViewMealArea({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ViewConditionArea extends StatelessWidget {
  const _ViewConditionArea({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _ViewMedicineArea extends StatelessWidget {
  const _ViewMedicineArea({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _ViewMemoArea extends StatelessWidget {
  const _ViewMemoArea({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _ViewEventArea extends StatelessWidget {
  const _ViewEventArea({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: children,
        ),
      ),
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
