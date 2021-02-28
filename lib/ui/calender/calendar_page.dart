import 'package:dyphic/common/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/ui/widget/app_calender.dart';
import 'package:dyphic/ui/calender/calendar_view_model.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/common/app_strings.dart';

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.calenderPageTitle)),
      body: ChangeNotifierProvider<CalendarViewModel>(
        create: (_) => CalendarViewModel.create(),
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
    return AppCalendar(
      events: viewModel.calendarEvents,
      onReturnEditPage: (isUpdate) {
        // TODO 記録情報が更新されたらカレンダーをリロードする。いちいち全部リロードは効率悪いので対象データだけにしたい。
        if (isUpdate) {
          AppLogger.d('記録情報が更新されました。');
        } else {
          AppLogger.d('更新されませんでした。');
        }
      },
    );
  }
}
