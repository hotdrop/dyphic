import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/ui/record/widgets/chips_condition.dart';
import 'package:dyphic/ui/record/widgets/chips_medicine.dart';
import 'package:dyphic/ui/record/widgets/meal_widget.dart';
import 'package:dyphic/ui/record/widgets/morning_temperature_widget.dart';
import 'package:dyphic/ui/record/widgets/app_check_box.dart';
import 'package:dyphic/ui/record/widgets/event_radio_group.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/record/record_controller.dart';
import 'package:line_icons/line_icons.dart';

///
/// このページはRecordsPageViewから構築されるのでスワイプでページ移動可能になっている。
/// なるべくスワイプでのページ移動をスムースにするためこのような作りにしている。
/// （途中、StateProviderを使った方法で試したがどうしてもスムースにページ移動できないのでやめた
///
class RecordPage extends ConsumerWidget {
  const RecordPage(this.recordId, {super.key});

  final int recordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordDate = DyphicID.idToDate(recordId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('yyyy年MM月dd日').format(recordDate),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder(
          future: ref.read(recordControllerProvider.notifier).find(recordId),
          builder: (BuildContext context, AsyncSnapshot<Record> snapshot) {
            if (snapshot.hasData) {
              return _ViewBody(snapshot.data!);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _ViewBody extends ConsumerStatefulWidget {
  const _ViewBody(this.record);

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
    final isSignIn = ref.read(isSignInProvider);

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
              const _ContentsTitle(
                title: '体調',
                titleColor: AppTheme.condition,
                appIcon: Icon(Icons.sentiment_satisfied_rounded, color: AppTheme.condition),
              ),
              const Divider(),
              FutureBuilder(
                future: ref.read(recordControllerProvider.notifier).fetchConditions(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ConditionSelectChips(
                      selectIds: _inputSelectConditionIds,
                      conditions: snapshot.data!,
                      onChange: (Set<int> ids) {
                        setState(() => _inputSelectConditionIds = ids);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
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
                label: '体調メモ',
                initValue: _inputConditionMemo,
                limitLine: 10,
                hintText: '細かい体調はこちらに記載しましょう！',
                onChanged: (String newVal) {
                  setState(() => _inputConditionMemo = newVal);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveCondition(context) : null,
                child: const Text('体調情報を保存する'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // お薬
          _ViewMedicineArea(
            children: [
              const _ContentsTitle(
                title: '服用した薬',
                titleColor: AppTheme.medicine,
                appIcon: Icon(LineIcons.capsules, color: AppTheme.medicine),
              ),
              const Divider(),
              FutureBuilder(
                future: ref.read(recordControllerProvider.notifier).fetchMedicines(),
                builder: (BuildContext context, AsyncSnapshot<List<Medicine>> snapshot) {
                  if (snapshot.hasData) {
                    return MedicineSelectChips(
                      selectIds: _inputSelectMedicineIds,
                      medicines: snapshot.data!,
                      onChanged: (Set<int> ids) {
                        setState(() => _inputSelectMedicineIds = ids);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: isSignIn ? () async => await _processSaveMedicine(context) : null,
                child: const Text('選択した薬を保存する'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // メモ
          _ViewMemoArea(
            children: [
              MultiLineTextField(
                label: '今日のメモ',
                initValue: _inputMemo,
                limitLine: 10,
                hintText: 'その他、残しておきたい記録があったらここに記載してください。',
                onChanged: (String? input) {
                  if (input != null) {
                    setState(() => _inputMemo = input);
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveMemo(context) : null,
                child: const Text('メモを保存する'),
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
                label: '予定名（放射線科、婦人科など）',
                initValue: _inputEventName,
                onChanged: (String newVal) {
                  setState(() => _inputEventName = newVal);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: (isSignIn) ? () async => await _processSaveEvent(context) : null,
                child: const Text('予定を保存する'),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Future<void> _processSaveBreakfast(String newVal) async {
    if (ref.read(isSignInProvider)) {
      ref.read(recordControllerProvider.notifier).inputBreakfast(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputBreakfast = newVal);
  }

  Future<void> _processSaveLunch(String newVal) async {
    if (ref.read(isSignInProvider)) {
      ref.read(recordControllerProvider.notifier).inputLunch(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputLunch = newVal);
  }

  Future<void> _processSaveDinner(String newVal) async {
    if (ref.read(isSignInProvider)) {
      ref.read(recordControllerProvider.notifier).inputDinner(id: widget.record.id, newVal: newVal);
    }
    setState(() => _inputDinner = newVal);
  }

  Future<void> _processSaveMorningTemperature(double? v) async {
    if (v != null && ref.read(isSignInProvider)) {
      ref.read(recordControllerProvider.notifier).inputMorningTemperature(id: widget.record.id, newVal: v);
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
        await ref.read(recordControllerProvider.notifier).saveCondition(
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
        await ref.read(recordControllerProvider.notifier).saveMedicine(
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
        await ref.read(recordControllerProvider.notifier).saveMemo(id: widget.record.id, memo: _inputMemo);
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
        await ref.read(recordControllerProvider.notifier).saveEvent(id: widget.record.id, eventType: _inputEventType, eventName: _inputEventName);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _ViewMealArea extends StatelessWidget {
  const _ViewMealArea({required this.children});

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
  const _ViewConditionArea({required this.children});

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
  const _ViewMedicineArea({required this.children});

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
  const _ViewMemoArea({required this.children});

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
  const _ViewEventArea({required this.children});

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
    required this.title,
    required this.titleColor,
    required this.appIcon,
  });

  final String title;
  final Color titleColor;
  final Icon appIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        appIcon,
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: titleColor)),
      ],
    );
  }
}
