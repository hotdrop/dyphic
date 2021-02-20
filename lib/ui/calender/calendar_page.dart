import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/ui/calender/calendar_view_model.dart';
import 'package:dyphic/ui/widget/app_calender.dart';

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.calenderPageTitle)),
      body: ChangeNotifierProvider<CalendarViewModel>(
        create: (_) => CalendarViewModel.create()..init(),
        builder: (context, viewModel) {
          final pageState = context.select<CalendarViewModel, PageLoadingState>((vm) => vm.pageState);
          if (pageState.isLoadSuccess) {
            return _loadSuccessView(context);
          } else {
            return _nowLoadingView();
          }
        },
        child: _nowLoadingView(),
      ),
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = context.read<CalendarViewModel>();
    return AppCalendar(events: viewModel.calendarEvents);
  }
}
