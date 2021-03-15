import 'package:dyphic/model/dyphic_id.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dyphic/ui/calender/record/record_page.dart';

import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/common/app_strings.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({required this.events, required this.onReturnEditPage});

  final List<CalendarEvent> events;
  final void Function(bool isUpdate, int id) onReturnEditPage;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends State<DyphicCalendar> {
  final Map<int, CalendarEvent> _events = {};

  final DateTime _focusDate = DateTime.now();

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
      headerStyle: HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventForDay,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange.withAlpha(70),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).accentColor,
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
      markers.add(Icon(Icons.medical_services, size: 15.0, color: Colors.red));
    } else if (event.typeInjection()) {
      markers.add(Icon(Icons.colorize, size: 15.0, color: Colors.red));
    } else {
      markers.add(SizedBox(width: 15.0));
    }

    if (event.haveRecord()) {
      markers.add(Icon(Icons.check_circle, size: 15.0, color: Colors.green));
    } else {
      markers.add(SizedBox(width: 15.0));
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
          child: _detailDailyRecord(),
        ),
      ),
    );
  }

  Widget _detailDailyRecord() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
    return Center(
      child: Text(_selectedEvent.name ?? AppStrings.calenderNoEvent),
    );
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];
    if (_selectedEvent.haveRecord()) {
      widgets.add(Text(AppStrings.calenderDetailConditionLabel));
      widgets.add(Text(_selectedEvent.toStringConditions()));
      widgets.add(SizedBox(height: 8.0));
      widgets.add(Text(AppStrings.calenderDetailConditionMemoLabel));
      widgets.add(_labelMemo());
    } else {
      widgets.add(Text(AppStrings.calenderUnRegisterLabel));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _labelMemo() {
    return Text(
      '${_selectedEvent.getConditionMemo()}',
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
