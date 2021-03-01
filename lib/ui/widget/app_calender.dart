import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:dyphic/ui/widget/app_widget.dart';

import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/calendar_event.dart';
import 'package:dyphic/common/app_strings.dart';

class AppCalendar extends StatefulWidget {
  const AppCalendar({Key key, this.events, this.onReturnEditPage}) : super(key: key);

  final List<CalendarEvent> events;
  final void Function(bool isUpdate) onReturnEditPage;

  @override
  _AppCalendarState createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCalendar(),
        const SizedBox(height: 8.0),
        _buildDetailContents(context),
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
  Widget _buildDetailContents(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.8, color: appSettings.isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _labelEventInfo(),
              DividerThemeColor.createWithPadding(),
              _labelRecordInfo(),
              DividerThemeColor.createWithPadding(),
              // TODO これタップで編集でいるようにしたほうがいいか
              _editButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelEventInfo() {
    return Center(
      child: Text(_selectedItem.name ?? AppStrings.calenderNoEvent),
    );
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];
    if (_selectedItem.haveRecord()) {
      widgets.add(_labelConditions());
      widgets.add(_labelMedicines());
      widgets.add(_labelMemo());
    } else {
      widgets.add(Text(AppStrings.calenderUnRegisterLabel));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _labelConditions() {
    return Text('体調: ${_selectedItem.toStringConditions()}');
  }

  Widget _labelMedicines() {
    return Text('飲んだ薬: ${_selectedItem.toStringMedicines()}');
  }

  Widget _labelMemo() {
    return Text(
      'メモ: ${_selectedItem.getMemo()}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _editButton() {
    return OutlineButton(
      child: Text(AppStrings.calenderRecordEditButton),
      onPressed: () async {
        final selectDate = _selectedItem.date;
        bool isUpdate = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => RecordPage(selectDate)),
            ) ??
            false;
        widget.onReturnEditPage(isUpdate);
      },
    );
  }
}
