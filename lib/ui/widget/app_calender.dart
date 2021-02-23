import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/ui/calender/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/calendar_event.dart';

class AppCalendar extends StatefulWidget {
  const AppCalendar({Key key, this.events}) : super(key: key);

  final List<CalendarEvent> events;

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
    if (event.haveRecord) {
      markers.add(Positioned(right: -2, bottom: -2, child: Icon(Icons.check_circle, size: 20.0, color: Colors.green)));
    }

    return markers;
  }

  ///
  /// タップした日付の記録情報をカレンダーの下に表示する
  ///
  Widget _buildDetailContents(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    // TODO レイアウトちゃんと考える
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(width: 0.8, color: appSettings.isDarkMode ? Colors.white : Colors.black),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(_selectedItem.haveRecord ? _selectedItem.name : '未登録です！登録しましょう！'),
              OutlineButton(
                child: Text('編集画面へ'),
                onPressed: () async {
                  final selectDate = _selectedItem.date;
                  bool isUpdate = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => RecordPage(selectDate)),
                      ) ??
                      false;
                  // TODO このボタンイベントは呼び元に委ねた方がいいか
                  if (isUpdate) {
                    AppLogger.d('記録情報が更新されました。');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
