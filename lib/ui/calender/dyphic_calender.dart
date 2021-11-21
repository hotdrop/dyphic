import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/ui/calender/record/records_page_view.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DyphicCalendar extends ConsumerStatefulWidget {
  const DyphicCalendar({required this.records, Key? key}) : super(key: key);

  final List<Record> records;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends ConsumerState<DyphicCalendar> {
  Map<int, Record> _recordMap = {};

  DateTime _focusDate = DateTime.now();
  DateTime? _selectedDate;
  Record? _selectedRecord;

  static const double calendarIconSize = 15.0;

  @override
  void initState() {
    super.initState();

    final nowId = DyphicID.makeRecordId(DateTime.now());
    _recordMap = _createMap(nowId, widget.records);

    _selectedRecord ??= Record.create(id: nowId);
    _selectedDate = _focusDate;
  }

  Map<int, Record> _createMap(int selectedId, List<Record> records) {
    final resultMap = <int, Record>{};

    final nowId = DyphicID.makeRecordId(DateTime.now());
    bool existNowDate = false;
    for (var record in records) {
      resultMap[record.id] = record;
      if (record.id == selectedId) {
        _selectedRecord = record;
      }
      if (record.id == nowId) {
        existNowDate = true;
      }
    }
    // 同日のデータがなければMapに追加する
    if (!existNowDate) {
      resultMap[nowId] = Record.create(id: nowId);
    }
    return resultMap;
  }

  List<Record> _getEventForDay(DateTime date) {
    final id = DyphicID.makeEventId(date);
    final event = _recordMap[id];
    return event != null ? [event] : [];
  }

  void _onDaySelected(DateTime date, {Record? selectedItem}) {
    setState(() {
      _focusDate = date;
      _selectedDate = date;

      if (selectedItem != null) {
        _selectedRecord = selectedItem;
      } else {
        final newId = DyphicID.makeRecordId(date);
        final newRecord = Record.create(id: newId);
        _recordMap[newId] = newRecord;
        _selectedRecord = newRecord;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCalendar(),
        const SizedBox(height: 8.0),
        _cardDailyRecord(context),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<Record>(
      firstDay: DateTime(2020, 11, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusDate,
      selectedDayPredicate: (date) => isSameDay(_selectedDate, date),
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 20, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventForDay,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange.withAlpha(70),
          shape: BoxShape.circle,
        ),
        todayDecoration: const BoxDecoration(
          color: AppColors.themeColor,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(markerBuilder: (ctx, date, events) => _buildMarker(events)),
      onDaySelected: (selectDate, focusDate) {
        final id = DyphicID.makeEventId(selectDate);
        if (_recordMap.containsKey(id)) {
          final record = _recordMap[id];
          _onDaySelected(selectDate, selectedItem: record);
        } else {
          _onDaySelected(selectDate);
        }
      },
    );
  }

  ///
  /// カレンダーの日付の下に表示するマーカーアイコンの処理
  ///
  Widget _buildMarker(List<Record> argRecords) {
    final markers = <Widget>[];

    if (argRecords.isEmpty) {
      return const SizedBox();
    }

    final record = argRecords.first;
    if (record.typeMedical()) {
      markers.add(Image.asset(
        AppImages.icHospital,
        width: calendarIconSize,
        height: calendarIconSize,
      ));
    } else if (record.typeInjection()) {
      markers.add(Image.asset(
        AppImages.icInject,
        width: calendarIconSize,
        height: calendarIconSize,
      ));
    } else if (record.morningTemperature != null) {
      markers.add(Image.asset(
        AppImages.icThermometerMorning,
        width: calendarIconSize,
        height: calendarIconSize,
      ));
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    if (record.isToilet) {
      markers.add(const SizedBox(width: calendarIconSize, child: Text('💩')));
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    if (record.isWalking) {
      markers.add(const SizedBox(width: calendarIconSize, child: Text('🚶‍♀️')));
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: markers,
    );
  }

  ///
  /// タップした日付の記録情報をカレンダーの下に表示する
  ///
  Widget _cardDailyRecord(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        elevation: 4.0,
        child: InkWell(
          onTap: () async => await _onTapCard(context),
          child: _detailDailyRecord(),
        ),
      ),
    );
  }

  Future<void> _onTapCard(BuildContext context) async {
    // indexでページスワイプをするので必ずソートする
    final records = _sortedRecords();
    final index = records.indexWhere((e) => _selectedRecord!.id == e.id);
    bool isUpdate = await RecordsPageView.start(context, records: records, selectedIndex: index);
    AppLogger.d('記録情報の更新有無: $isUpdate');
    if (isUpdate) {
      await ref.read(recordsProvider.notifier).onLoad();
      final newRecords = ref.watch(recordsProvider);
      setState(() {
        _recordMap = _createMap(_selectedRecord!.id, newRecords);
      });
    }
  }

  List<Record> _sortedRecords() {
    final l = _recordMap.values.toList();
    l.sort((a, b) => a.id.compareTo(b.id));
    return l;
  }

  Widget _detailDailyRecord() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelEventInfo(),
            const Divider(),
            _labelRecordInfo(),
          ],
        ),
      ),
    );
  }

  Widget _labelEventInfo() {
    final dateStr = DateFormat(AppStrings.calenderPageDateFormat).format(_selectedRecord!.date);
    if (_selectedRecord!.event?.name != null) {
      return Center(
        child: Text(
          '$dateStr(${_selectedRecord!.event!.name})',
          style: const TextStyle(color: AppColors.themeColor),
        ),
      );
    } else {
      return Center(
        child: Text('$dateStr(${AppStrings.calenderNoEvent})'),
      );
    }
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];

    final sr = _selectedRecord;
    if (sr == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text(AppStrings.calenderUnRegisterLabel)],
      );
    }

    // 体調
    if (sr.conditions.isNotEmpty) {
      widgets.add(Text(sr.toConditionNames()));
      widgets.add(const SizedBox(height: 8));
    }

    if (sr.morningTemperature != null) {
      widgets.add(Text(
        '${AppStrings.calenderDetailMorningTempLabel} ${sr.morningTemperature}',
        style: const TextStyle(
          color: AppColors.themeAccent,
        ),
      ));
      widgets.add(const SizedBox(height: 8));
    }

    // 体調メモ
    final conditionMemo = sr.conditionMemo ?? '';
    if (conditionMemo.isNotEmpty) {
      widgets.add(Text(conditionMemo));
      widgets.add(const SizedBox(height: 8));
    }

    // 通常メモ
    final memo = sr.memo ?? '';
    if (memo.isNotEmpty) {
      widgets.add(Text(memo));
      widgets.add(const SizedBox(height: 16));
    }

    if (widgets.isEmpty) {
      widgets.add(const Text(AppStrings.calenderUnRegisterLabel));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
