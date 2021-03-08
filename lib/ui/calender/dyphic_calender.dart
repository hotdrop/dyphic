import 'package:dyphic/model/dyphic_id.dart';
import 'package:dyphic/ui/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:dyphic/ui/widget/app_divider.dart';

import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/common/app_strings.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({Key key, this.events, this.onReturnEditPage}) : super(key: key);

  final List<CalendarEvent> events;
  final void Function(bool isUpdate, int id) onReturnEditPage;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends State<DyphicCalendar> {
  CalendarController _calendarController;
  Map<DateTime, List<CalendarEvent>> _events;
  CalendarEvent _selectedItem;

  @override
  void initState() {
    super.initState();
    _events = {};
    final nowDate = DateTime.now();
    widget.events.forEach((event) {
      _events[event.date] = [event];
      if (CalendarEvent.isSameDay(nowDate, event.date)) {
        _selectedItem = event;
      }
    });
    if (_selectedItem == null) {
      _selectedItem = CalendarEvent.createEmpty(nowDate);
    }
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  void _onDaySelected(DateTime date, {CalendarEvent selectedItem}) {
    setState(() {
      _selectedItem = selectedItem ?? CalendarEvent.createEmpty(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO 記録情報を登録して戻ってくるとレンダリングが一瞬おかしくなる。
    //     The overflowing RenderFlex has an orientation of Axis.vertical.
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCalendar(),
        _cardDailyRecord(context),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ja_JP',
      calendarController: _calendarController,
      events: _events,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange.withAlpha(70),
        todayColor: Colors.lightBlue,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(formatButtonVisible: false),
      builders: CalendarBuilders(markersBuilder: (context, date, events, holidays) => _buildMarkers(events)),
      onDaySelected: (date, events, holidays) {
        if (events.isEmpty) {
          _onDaySelected(date);
        } else {
          final event = events.first as CalendarEvent;
          _onDaySelected(date, selectedItem: event);
        }
      },
    );
  }

  ///
  /// カレンダーの日付の下に表示するマーカーアイコンの処理
  ///
  List<Widget> _buildMarkers(List<dynamic> argEvents) {
    final markers = <Widget>[];

    if (argEvents.isEmpty) {
      return markers;
    }

    final event = argEvents.first as CalendarEvent;
    if (event.typeMedical()) {
      markers.add(Positioned(bottom: -1, child: Icon(Icons.medical_services, size: 20.0, color: Colors.red)));
    }
    if (event.typeInjection()) {
      markers.add(Positioned(bottom: -1, child: Icon(Icons.colorize, size: 20.0, color: Colors.red)));
    }
    if (event.haveRecord()) {
      markers.add(Positioned(right: -2, bottom: -2, child: Icon(Icons.check_circle, size: 20.0, color: Colors.green)));
    }

    return markers;
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
          child: _detailDailyRecord(),
          onTap: () async {
            final selectDate = _selectedItem.date;
            bool isUpdate = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => RecordPage(selectDate)),
                ) ??
                false;
            final recordId = DyphicID.makeRecordId(selectDate);
            widget.onReturnEditPage(isUpdate, recordId);
          },
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
            DividerThemeColor.create(),
            _labelRecordInfo(),
          ],
        ),
      ),
    );
  }

  Widget _labelEventInfo() {
    return Center(
      child: AppText.normal(_selectedItem.name ?? AppStrings.calenderNoEvent),
    );
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];
    if (_selectedItem.haveRecord()) {
      widgets.add(_labelConditions());
      widgets.add(_labelMemo());
    } else {
      widgets.add(AppText.normal(AppStrings.calenderUnRegisterLabel));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _labelConditions() {
    return AppText.normal('${AppStrings.calenderDetailConditionLabel} ${_selectedItem.toStringConditions()}');
  }

  Widget _labelMemo() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppText.multiLine(
        '${_selectedItem.getConditionMemo()}',
        maxLines: 5,
      ),
    );
  }
}
