import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_integer.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({required this.events, required this.onReturnEditPage});

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

  @override
  void initState() {
    super.initState();
    final nowDate = DateTime.now();
    widget.events.forEach((event) {
      _events[event.id] = event;
      if (CalendarEvent.isSameDay(nowDate, event.date)) {
        _selectedEvent = event;
      }
    });
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
        _buildCalendar(context),
        SizedBox(height: 8.0),
        _cardDailyRecord(context),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar<CalendarEvent>(
      firstDay: DateTime(2020, 11, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusDate,
      selectedDayPredicate: (date) => isSameDay(_selectedDate, date),
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 18.0, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventForDay,
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
      calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) => _buildMarker(events)),
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
      return SizedBox();
    }

    final event = argEvents.first;
    if (event.typeMedical()) {
      markers.add(
          Image.asset('res/images/ic_hospital.png', width: AppInteger.calendarIconSize, height: AppInteger.calendarIconSize));
    } else if (event.typeInjection()) {
      markers
          .add(Image.asset('res/images/ic_inject.png', width: AppInteger.calendarIconSize, height: AppInteger.calendarIconSize));
    } else {
      markers.add(SizedBox(width: AppInteger.calendarIconSize));
    }

    if (event.haveRecord()) {
      markers.add(Icon(Icons.note_rounded, size: AppInteger.calendarIconSize, color: Colors.green));
      final isWalk = event.recordOverview?.isWalking ?? false;
      if (isWalk) {
        markers.add(Icon(Icons.directions_walk, size: AppInteger.calendarIconSize, color: AppColors.walking));
      } else {
        markers.add(SizedBox(width: AppInteger.calendarIconSize));
      }
    } else {
      markers.add(SizedBox(width: AppInteger.calendarIconSize));
      markers.add(SizedBox(width: AppInteger.calendarIconSize));
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
            final selectDate = _selectedEvent.date;
            final isUpdate = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => RecordPage(selectDate)),
                ) ??
                false;
            final recordId = DyphicID.makeRecordId(selectDate);
            widget.onReturnEditPage(isUpdate, recordId);
          },
          child: _detailDailyRecord(context),
        ),
      ),
    );
  }

  Widget _detailDailyRecord(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelEventInfo(context),
            const Divider(),
            _labelRecordInfo(),
          ],
        ),
      ),
    );
  }

  Widget _labelEventInfo(BuildContext context) {
    if (_selectedEvent.name != null) {
      return Center(
        child: Text(
          _selectedEvent.name!,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      );
    } else {
      return Center(
        child: Text(AppStrings.calenderNoEvent),
      );
    }
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];

    if (_selectedEvent.haveRecord()) {
      // 体調
      widgets.add(Text(_selectedEvent.toStringConditions()));
      widgets.add(SizedBox(height: 8.0));

      // 散歩
      if (_selectedEvent.isWalking()) {
        widgets.add(Text(AppStrings.calenderDetailWalkingLabel, style: TextStyle(color: AppColors.walking)));
        widgets.add(SizedBox(height: 8.0));
      }

      // 体調メモ
      final memo = _selectedEvent.getConditionMemo();
      if (memo.isNotEmpty) {
        widgets.add(Text(AppStrings.calenderDetailConditionMemoLabel));
        widgets.add(_labelMemo(memo));
      }
    } else {
      widgets.add(Text(AppStrings.calenderUnRegisterLabel));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _labelMemo(String memo) {
    return Text(
      '$memo',
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
