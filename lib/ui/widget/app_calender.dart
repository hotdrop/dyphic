import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dalico/model/calendar_item.dart';

class AppCalendar extends StatefulWidget {
  @override
  _AppCalendarState createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  CalendarController _calendarController;
  Map<DateTime, List<CalendarItem>> _items;
  CalendarItem _selectedItem;

  @override
  void initState() {
    super.initState();
    // TODO Repositoryから持ってくる
    _items = {
      DateTime(2021, 2, 10): [CalendarItem(id: 1, date: DateTime(2021, 2, 10), type: 1, name: '薬飲んだ', recordId: 1)],
      DateTime(2021, 2, 11): [CalendarItem(id: 2, date: DateTime(2021, 2, 11), type: 2, name: 'アイウエオ', recordId: 2)]
    };
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  void _onDaySelected(DateTime date, {CalendarItem selectedItem}) {
    setState(() {
      _selectedItem = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCalendar(),
        const SizedBox(height: 8.0),
        _buildDetailContents(),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ja_JP',
      calendarController: _calendarController,
      events: _items,
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
          final item = events.first as CalendarItem;
          _onDaySelected(date, selectedItem: item);
        }
      },
    );
  }

  ///
  /// カレンダーの日付の下に表示するマーカーアイコンの処理
  ///
  List<Widget> _buildMarkers(List<dynamic> items) {
    final markers = <Widget>[];

    if (items.isEmpty) {
      return markers;
    }

    final item = items.first as CalendarItem;

    if (item.typeMedical()) {
      markers.add(Positioned(
        bottom: -1,
        child: Icon(Icons.medical_services, size: 20.0, color: Colors.red),
      ));
    }

    markers.add(Positioned(
      right: -2,
      bottom: -2,
      child: Icon(Icons.check_circle, size: 20.0, color: Colors.green),
    ));

    return markers;
  }

  ///
  /// タップした日付の記録情報をカレンダーの下に表示する
  ///
  Widget _buildDetailContents() {
    // TODO
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(_selectedItem != null ? _selectedItem.name : '未登録です！登録しましょう！'),
        ),
      ),
    );
  }
}
