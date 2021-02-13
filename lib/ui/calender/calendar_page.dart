import 'package:dalico/common/app_strings.dart';
import 'package:dalico/ui/widget/app_calender.dart';
import 'package:flutter/material.dart';

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.calenderPageTitle),
      ),
      body: Column(
        children: [
          AppCalendar(),
        ],
      ),
    );
  }
}
