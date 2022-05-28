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

class RecordPage extends ConsumerWidget {
  const RecordPage(this.record, {Key? key}) : super(key: key);

  // TODO ここで保持しているレコードでPageViewスライド時の画面初期化を行なっているので、値を更新してスライドすると元の値に戻ってしまう・・
  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        recordViewModel.overrideWithProvider(recordViewModelFamily(record.id)),
      ],
      child: Consumer(
        builder: (context, ref, child) => _ViewBody(record),
      ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void>.delayed(Duration.zero).then((_) {
      ref.read(recordViewModel).init(record);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(AppStrings.recordPageTitleDateFormat).format(record.date)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView(
            children: const [
              _ViewMealArea(),
              _ViewTemperatureArea(),
              _ViewConditionArea(),
              SizedBox(height: 16.0),
              _ViewMedicineArea(),
              SizedBox(height: 16.0),
              _ViewSaveMemoArea(),
              SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewMealArea extends StatelessWidget {
  const _ViewMealArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _ViewBreakfastCard(),
              SizedBox(width: 4),
              _ViewLunchCard(),
              SizedBox(width: 4),
              _ViewDinnerCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewBreakfastCard extends ConsumerWidget {
  const _ViewBreakfastCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.morning(
      detail: ref.watch(breakfastProvider),
      onSubmitted: (String? v) async {
        if (v != null) {
          await ref.read(recordViewModel).inputBreakfast(v);
        }
      },
    );
  }
}

class _ViewLunchCard extends ConsumerWidget {
  const _ViewLunchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.lunch(
      detail: ref.watch(lunchProvider),
      onSubmitted: (String? v) async {
        if (v != null) {
          await ref.read(recordViewModel).inputLunch(v);
        }
      },
    );
  }
}

class _ViewDinnerCard extends ConsumerWidget {
  const _ViewDinnerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MealCard.dinner(
      detail: ref.watch(dinnerProvider),
      onSubmitted: (String? v) {
        if (v != null) {
          ref.read(recordViewModel).inputDinner(v);
        }
      },
    );
  }
}

class _ViewTemperatureArea extends StatelessWidget {
  const _ViewTemperatureArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _ViewTemperatureMorning(),
          _ViewTemperatureNight(),
        ],
      ),
    );
  }
}

class _ViewTemperatureMorning extends ConsumerWidget {
  const _ViewTemperatureMorning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemperatureView.morning(
      temperature: ref.watch(morningTemperatureProvider),
      onSubmitted: (double? newVal) {
        if (newVal != null) {
          ref.read(recordViewModel).inputMorningTemperature(newVal);
        }
      },
    );
  }
}

class _ViewTemperatureNight extends ConsumerWidget {
  const _ViewTemperatureNight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemperatureView.night(
      temperature: ref.watch(nightTemperatureProvider),
      onSubmitted: (double? newVal) async {
        if (newVal != null) {
          await ref.read(recordViewModel).inputNightTemperature(newVal);
        }
      },
    );
  }
}

class _ViewConditionArea extends StatelessWidget {
  const _ViewConditionArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const _ViewConditionSelectChips(),
            const _ViewConditionCheckBoxes(),
            const _ViewConditionMemo(),
            const SizedBox(height: 8.0),
            const _ViewConditionSaveButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewConditionSelectChips extends ConsumerWidget {
  const _ViewConditionSelectChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConditionSelectChips(
      selectIds: ref.watch(selectConditionIdsProvider),
      onChange: (Set<int> ids) {
        AppLogger.d('選択している症状は $ids です');
        ref.read(recordViewModel).selectConditionIds(ids);
      },
    );
  }
}

class _ViewConditionCheckBoxes extends ConsumerWidget {
  const _ViewConditionCheckBoxes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: ref.watch(isWalkingProvider),
          onChanged: (bool isCheck) {
            AppLogger.d('歩いたチェック: $isCheck');
            ref.read(recordViewModel).inputIsWalking(isCheck);
          },
        ),
        AppCheckBox.toilet(
          initValue: ref.watch(isToiletProvider),
          onChanged: (bool isCheck) {
            AppLogger.d('トイレチェック: $isCheck');
            ref.read(recordViewModel).inputIsToilet(isCheck);
          },
        ),
      ],
    );
  }
}

class _ViewConditionMemo extends ConsumerWidget {
  const _ViewConditionMemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.recordConditionMemoTitle,
      initValue: ref.watch(conditionMemoProvider),
      limitLine: 10,
      hintText: AppStrings.recordConditionMemoHint,
      onChanged: (String? input) {
        ref.read(recordViewModel).inputMemo(input ?? '');
      },
    );
  }
}

class _ViewConditionSaveButton extends ConsumerWidget {
  const _ViewConditionSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      execute: () async {
        await ref.read(recordViewModel).saveCondition();
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _ViewMedicineArea extends StatelessWidget {
  const _ViewMedicineArea({Key? key}) : super(key: key);

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
            const _ViewMedicineSelectChips(),
            const _ViewMedicineSaveButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewMedicineSelectChips extends ConsumerWidget {
  const _ViewMedicineSelectChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineSelectChips(
      selectIds: ref.watch(selectMedicineIdsProvider),
      onChanged: (Set<int> ids) {
        AppLogger.d('選択しているお薬は $ids です');
        ref.read(recordViewModel).selectMedicineIds(ids);
      },
    );
  }
}

class _ViewMedicineSaveButton extends ConsumerWidget {
  const _ViewMedicineSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      execute: () async {
        await ref.read(recordViewModel).saveMedicine();
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _ViewSaveMemoArea extends StatelessWidget {
  const _ViewSaveMemoArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            _ViewMemoTextField(),
            SizedBox(height: 8.0),
            _ViewMemoSaveButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewMemoTextField extends ConsumerWidget {
  const _ViewMemoTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.recordMemoTitle,
      initValue: ref.watch(memoProvider),
      limitLine: 10,
      hintText: AppStrings.recordMemoHint,
      onChanged: (String? input) {
        ref.read(recordViewModel).inputMemo(input ?? '');
      },
    );
  }
}

class _ViewMemoSaveButton extends ConsumerWidget {
  const _ViewMemoSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _saveMemo(context, ref) : null,
      child: const Text(AppStrings.recordMemoSaveButton),
    );
  }

  Future<void> _saveMemo(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModel).saveMemo();
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
