import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/ui/record/records_page_view.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/calender/calendar_controller.dart';

class CalenderPage extends ConsumerWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: ref.watch(calendarControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, stackTrace) {
              return Center(
                child: Text('$err', style: const TextStyle(color: Colors.red)),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _ViewCalendar(),
        SizedBox(height: 8.0),
        _ViewSelectedDayInfoCard(),
      ],
    );
  }
}

class _ViewCalendar extends ConsumerWidget {
  const _ViewCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datamap = ref.watch(calendarRecordsMapStateProvder);

    return TableCalendar<Record>(
      firstDay: DateTime(2020, 11, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: ref.watch(calendarFocusDateStateProvider),
      selectedDayPredicate: (date) {
        final selectedDate = ref.read(calendarSelectedDateStateProvider);
        return isSameDay(selectedDate, date);
      },
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 18.0, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: (dateTime) => ref.read(calendarControllerProvider.notifier).getRecordForDay(datamap, dateTime),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange.withAlpha(70),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) => _ViewMarker(events),
      ),
      onDaySelected: (selectDate, focusDate) {
        ref.read(calendarControllerProvider.notifier).onDaySelected(selectDate);
      },
    );
  }
}

///
/// カレンダーの日付の下に表示するマーカーアイコン
///
class _ViewMarker extends StatelessWidget {
  const _ViewMarker(this.records);

  final List<Record> records;
  static const double _iconSize = 15;

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildMarker(),
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> _buildMarker() {
    final markers = <Widget>[];
    final record = records.first;

    if (record.typeMedical) {
      markers.add(Image.asset(AppImages.icHospital, width: _iconSize, height: _iconSize));
    } else if (record.typeInjection) {
      markers.add(Image.asset(AppImages.icInject, width: _iconSize, height: _iconSize));
    } else if (record.morningTemperature != null) {
      markers.add(Image.asset(AppImages.icThermometerMorning, width: _iconSize, height: _iconSize));
    } else {
      markers.add(const SizedBox(width: _iconSize));
    }

    if (record.isToilet) {
      markers.add(const SizedBox(width: _iconSize, child: Text('💩')));
    } else {
      markers.add(const SizedBox(width: _iconSize));
    }

    if (record.isWalking) {
      markers.add(const SizedBox(width: _iconSize, child: Text('🚶‍♀️')));
    } else {
      markers.add(const SizedBox(width: _iconSize));
    }

    return markers;
  }
}

///
/// タップした日付の記録情報をカレンダーの下に表示するカードビュー
///
class _ViewSelectedDayInfoCard extends ConsumerWidget {
  const _ViewSelectedDayInfoCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4.0,
        child: InkWell(
          onTap: () async => await _onTap(context, ref),
          child: const _ViewContentsOnInfoCard(),
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    // indexでページスワイプをするので必ずソートする
    final recordKeysMap = ref.read(calendarRecordsMapStateProvder).keys.toList();
    recordKeysMap.sort((a, b) => a.compareTo(b));

    final selectedRecord = ref.read(calendarSelectedRecordStateProvider);
    final index = recordKeysMap.indexWhere((id) => id == selectedRecord.id);

    await RecordsPageView.start(context, recordIds: recordKeysMap, selectedIndex: index);

    // TODO ここは今カレンダーの情報全更新しているが、更新した記録情報のIDをリストで保持し、該当IDのものののみ更新した方がいい
    final isUpdate = ref.read(updateEditRecordStateProvider);
    AppLogger.d('記録情報の更新有無: $isUpdate');
    if (isUpdate) {
      await ref.read(calendarControllerProvider.notifier).onLoadRecords();
      ref.read(calendarControllerProvider.notifier).clearUpdateRecordFlag();
    }
  }
}

///
/// タップした日付の記録情報をカレンダーの下に表示するカードビューのうちコンテンツ部分
///
class _ViewContentsOnInfoCard extends StatelessWidget {
  const _ViewContentsOnInfoCard();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ViewHeaderOnInfoCard(),
            Divider(),
            _ViewDetailOnInfoCard(),
          ],
        ),
      ),
    );
  }
}

class _ViewHeaderOnInfoCard extends ConsumerWidget {
  const _ViewHeaderOnInfoCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = ref.watch(calendarSelectedRecordStateProvider).showFormatDate();
    final eventName = ref.watch(calendarSelectedRecordStateProvider).eventName;
    if (eventName != null) {
      return Center(
        child: Text(
          '$dateStr($eventName)',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Center(
        child: Text('$dateStr(予定なし)'),
      );
    }
  }
}

class _ViewDetailOnInfoCard extends ConsumerWidget {
  const _ViewDetailOnInfoCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(calendarSelectedRecordStateProvider);
    if (record.notRegister()) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('この日の記録は未登録です。\nここをタップして記録しましょう。'),
        ],
      );
    }

    final widgets = <Widget>[];
    // 体調
    if (record.conditions.isNotEmpty) {
      widgets.add(Text(record.toConditionNames()));
      widgets.add(const SizedBox(height: 8));
    }

    if (record.morningTemperature != null) {
      widgets.add(Text(
        '朝の体温: ${record.morningTemperature}',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ));
      widgets.add(const SizedBox(height: 8));
    }

    // 体調メモ
    final conditionMemo = record.conditionMemo ?? '';
    if (conditionMemo.isNotEmpty) {
      widgets.add(Text(conditionMemo));
      widgets.add(const SizedBox(height: 8));
    }

    // 通常メモ
    final memo = record.memo ?? '';
    if (memo.isNotEmpty) {
      widgets.add(Text(memo));
      widgets.add(const SizedBox(height: 16));
    }

    if (widgets.isEmpty) {
      widgets.add(const Text('この日の記録は未登録です。\nここをタップして記録しましょう。'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
