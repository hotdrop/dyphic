import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/calender/record/widget_condition_area.dart';
import 'package:dyphic/ui/calender/record/widget_medicine_area.dart';
import 'package:dyphic/ui/calender/record/widget_memo_area.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/meal_card.dart';
import 'package:dyphic/ui/widget/temperature_view.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage(this._record, {Key? key}) : super(key: key);

  final Record _record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(AppStrings.recordPageTitleDateFormat).format(_record.date)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView(
            children: <Widget>[
              _mealViewArea(context, ref),
              _temperatureViewArea(ref),
              ConditionArea(_record),
              const SizedBox(height: 16.0),
              MedicineArea(_record.id, _record.medicines),
              const SizedBox(height: 16.0),
              MemoArea(_record.id, _record.memo),
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
                onSubmitted: (String? v) async {
                  await ref.read(recordViewModelProvider).inputBreakfast(id: _record.id, newVal: v ?? '');
                },
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                detail: _record.lunch ?? '',
                onSubmitted: (String? v) async {
                  await ref.read(recordViewModelProvider).inputLunch(id: _record.id, newVal: v ?? '');
                },
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                detail: _record.dinner ?? '',
                onSubmitted: (String? v) {
                  ref.read(recordViewModelProvider).inputDinner(id: _record.id, newVal: v ?? '');
                },
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
            onSubmitted: (double? v) {
              ref.read(recordViewModelProvider).inputMorningTemperature(id: _record.id, newVal: v ?? 0);
            },
          ),
          TemperatureView.night(
            temperature: _record.nightTemperature ?? 0,
            onSubmitted: (double? v) async {
              await ref.read(recordViewModelProvider).inputNightTemperature(id: _record.id, newVal: v ?? 0);
            },
          ),
        ],
      ),
    );
  }
}
