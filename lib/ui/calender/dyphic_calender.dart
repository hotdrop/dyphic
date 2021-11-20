import 'package:dyphic/model/record.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({
    Key? key,
    required this.records,
    required this.onReturnEditPage,
  }) : super(key: key);

  final List<Record> records;
  final void Function(bool isUpdate, int id) onReturnEditPage;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends State<DyphicCalendar> {
  final Map<int, Record> _recordMap = {};

  DateTime _focusDate = DateTime.now();
  DateTime? _selectedDate;
  Record _selectedRecord = Record.create(id: DyphicID.makeRecordId(DateTime.now()));

  static const double calendarIconSize = 15.0;

  @override
  void initState() {
    super.initState();
    final nowDate = DateTime.now();
    for (var record in widget.records) {
      _recordMap[record.id] = record;
      if (Record.isSameDay(nowDate, record.date)) {
        _selectedRecord = record;
      }
    }
    _selectedDate = _focusDate;
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
      _selectedRecord = selectedItem ?? Record.create(id: DyphicID.makeRecordId(date));
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
          final event = _recordMap[id];
          _onDaySelected(selectDate, selectedItem: event);
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
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    if (record.isToilet) {
      markers.add(const SizedBox(width: calendarIconSize, child: Text('💩')));
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    if (record.isWalking) {
      markers.add(const Icon(Icons.directions_walk, size: calendarIconSize, color: AppColors.walking));
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
          onTap: () async {
            final isUpdate = await RecordPage.start(context, _selectedRecord);
            final recordId = DyphicID.makeRecordId(_selectedRecord.date);
            widget.onReturnEditPage(isUpdate, recordId);
          },
          child: _detailDailyRecord(),
        ),
      ),
    );
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
    final dateStr = DateFormat(AppStrings.calenderPageDateFormat).format(_selectedRecord.date);
    if (_selectedRecord.event?.name != null) {
      return Center(
        child: Text(
          '$dateStr(${_selectedRecord.event!.name})',
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

    // 体調
    if (_selectedRecord.conditions.isNotEmpty) {
      widgets.add(Text(_selectedRecord.toConditionNames()));
      widgets.add(const SizedBox(height: 8.0));
    }

    // 散歩
    if (_selectedRecord.isWalking) {
      widgets.add(const Text(AppStrings.calenderDetailWalkingLabel, style: TextStyle(color: AppColors.walking)));
      widgets.add(const SizedBox(height: 8.0));
    }

    // 体調メモ
    final memo = _selectedRecord.conditionMemo ?? '';
    if (memo.isNotEmpty) {
      widgets.add(const Text(AppStrings.calenderDetailConditionMemoLabel));
      widgets.add(Text(memo, maxLines: 10, overflow: TextOverflow.ellipsis));
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
