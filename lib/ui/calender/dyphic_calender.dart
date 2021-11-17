import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/res/app_images.dart';
import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({
    Key? key,
    required this.events,
    required this.onReturnEditPage,
  }) : super(key: key);

  final List<CalendarEvent> events;
  final void Function(bool isUpdate, int id) onReturnEditPage;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends State<DyphicCalendar> {
  final Map<int, CalendarEvent> _events = {};

  DateTime _focusDate = DateTime.now();
  DateTime? _selectedDate;
  CalendarEvent _selectedEvent = CalendarEvent.createEmpty(DateTime.now());

  static const double calendarIconSize = 15.0;

  @override
  void initState() {
    super.initState();
    final nowDate = DateTime.now();
    for (var event in widget.events) {
      _events[event.id] = event;
      if (CalendarEvent.isSameDay(nowDate, event.date)) {
        _selectedEvent = event;
      }
    }
    _selectedDate = _focusDate;
  }

  List<CalendarEvent> _getEventForDay(DateTime date) {
    final id = DyphicID.makeEventId(date);
    final event = _events[id];
    return event != null ? [event] : [];
  }

  void _onDaySelected(DateTime date, {CalendarEvent? selectedItem}) {
    setState(() {
      _focusDate = date;
      _selectedDate = date;
      _selectedEvent = selectedItem ?? CalendarEvent.createEmpty(date);
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
    return TableCalendar<CalendarEvent>(
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
        if (_events.containsKey(id)) {
          final event = _events[id];
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
  Widget _buildMarker(List<CalendarEvent> argEvents) {
    final markers = <Widget>[];

    if (argEvents.isEmpty) {
      return const SizedBox();
    }

    final event = argEvents.first;
    if (event.typeMedical()) {
      markers.add(Image.asset(
        AppImages.icHospital,
        width: calendarIconSize,
        height: calendarIconSize,
      ));
    } else if (event.typeInjection()) {
      markers.add(Image.asset(
        AppImages.icInject,
        width: calendarIconSize,
        height: calendarIconSize,
      ));
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
    }

    if (event.haveRecord()) {
      final isToilet = event.recordOverview?.isToilet ?? false;
      if (isToilet) {
        markers.add(const SizedBox(width: calendarIconSize, child: Text('💩')));
      } else {
        markers.add(const SizedBox(width: calendarIconSize));
      }
      final isWalk = event.recordOverview?.isWalking ?? false;
      if (isWalk) {
        markers.add(const Icon(Icons.directions_walk, size: calendarIconSize, color: AppColors.walking));
      } else {
        markers.add(const SizedBox(width: calendarIconSize));
      }
    } else {
      markers.add(const SizedBox(width: calendarIconSize));
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
            final isUpdate = await RecordPage.start(context, _selectedEvent.date);
            final recordId = DyphicID.makeRecordId(_selectedEvent.date);
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
    final dateStr = DateFormat(AppStrings.calenderPageDateFormat).format(_selectedEvent.date);
    if (_selectedEvent.name != null) {
      return Center(
        child: Text(
          '$dateStr(${_selectedEvent.name!})',
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

    if (_selectedEvent.haveRecord()) {
      // 体調
      widgets.add(Text(_selectedEvent.toStringConditions()));
      widgets.add(const SizedBox(height: 8.0));

      // 散歩
      if (_selectedEvent.isWalking()) {
        widgets.add(const Text(AppStrings.calenderDetailWalkingLabel, style: TextStyle(color: AppColors.walking)));
        widgets.add(const SizedBox(height: 8.0));
      }

      // 体調メモ
      final memo = _selectedEvent.getConditionMemo();
      if (memo.isNotEmpty) {
        widgets.add(const Text(AppStrings.calenderDetailConditionMemoLabel));
        widgets.add(Text(memo, maxLines: 10, overflow: TextOverflow.ellipsis));
      }
    } else {
      widgets.add(const Text(AppStrings.calenderUnRegisterLabel));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
