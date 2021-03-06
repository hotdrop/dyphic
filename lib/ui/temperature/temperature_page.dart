import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/temperature/temperature_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dyphic/ui/temperature/temperature_view_model.dart';

class TemperaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TemperatureViewModel>(
      create: (_) => TemperatureViewModel.create(),
      builder: (context, _) {
        final pageState = context.select<TemperatureViewModel, PageLoadingState>((vm) => vm.pageState);
        if (pageState.isLoadSuccess) {
          return _loadSuccessView(context);
        } else {
          return _nowLoadingView();
        }
      },
      child: _nowLoadingView(),
    );
  }

  Widget _nowLoadingView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.temperaturePageTitle),
      ),
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.temperaturePageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: _contentsView(context),
      ),
    );
  }

  Widget _contentsView(BuildContext context) {
    final viewModel = Provider.of<TemperatureViewModel>(context);
    return TemperatureGraph(morningDatas: viewModel.mornings, nightDatas: viewModel.nights);
  }
}
