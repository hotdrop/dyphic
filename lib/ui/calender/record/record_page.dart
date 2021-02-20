import 'package:dalico/common/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dalico/model/page_state.dart';
import 'package:dalico/ui/calender/record/record_view_model.dart';

class RecordPage extends StatelessWidget {
  const RecordPage(this._id);

  final int _id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordViewModel>(
      create: (_) => RecordViewModel.create(_id)..init(),
      builder: (context, _) {
        final pageState = context.select<RecordViewModel, PageState>((vm) => vm.pageState);
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
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.recordPageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(viewModel.record.formatDate())),
      body: _contentsView(context),
    );
  }

  Widget _contentsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: ListView(
        children: <Widget>[
          _foodViewArea(),
          _medicineViewArea(),
          _temperatureViewArea(),
          _conditionViewArea(),
          _memoView(),
        ],
      ),
    );
  }

  Widget _foodViewArea() {
    // TODO
  }

  Widget _medicineViewArea() {
    // TODO
  }

  Widget _temperatureViewArea() {
    // TODO
  }

  Widget _conditionViewArea() {
    // TODO
  }

  Widget _memoView() {
    // TODO
  }
}
