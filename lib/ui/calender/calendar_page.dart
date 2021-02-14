import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/app_settings.dart';
import 'package:dalico/model/page_state.dart';
import 'package:dalico/ui/calender/calendar_view_model.dart';
import 'package:dalico/ui/widget/app_calender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return ChangeNotifierProvider<CalendarViewModel>(
      create: (_) => CalendarViewModel.create()..init(appSettings),
      builder: (context, _) {
        final pageState = context.select<CalendarViewModel, PageState>((vm) => vm.pageState);
        if (pageState.nowLoading()) {
          return _nowLoadingView();
        } else {
          return _loadSuccessView(context);
        }
      },
      child: _nowLoadingView(),
    );
  }

  Widget _nowLoadingView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.calenderPageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = context.read<CalendarViewModel>();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.calenderPageTitle)),
      body: AppCalendar(events: viewModel.calendarEvents),
    );
  }
}
