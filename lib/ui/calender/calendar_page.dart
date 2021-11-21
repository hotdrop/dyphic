import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:flutter/material.dart';

import 'package:dyphic/ui/calender/dyphic_calender.dart';
import 'package:dyphic/ui/calender/calendar_view_model.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalenderPage extends ConsumerWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(calendarViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.calenderPageTitle),
      ),
      body: uiState.when(
        loading: (err) => _onLoading(context, err),
        success: () => _onSuccess(context, ref),
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return DyphicCalendar(
      records: ref.watch(recordsProvider),
      onReturn: () async {
        await ref.read(calendarViewModelProvider).reLoad();
      },
    );
  }
}
