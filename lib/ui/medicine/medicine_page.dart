import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/page_state.dart';
import 'package:dalico/ui/medicine/medicine_card_view.dart';
import 'package:dalico/ui/medicine/medicine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicineViewModel>(
      create: (_) => MedicineViewModel.create()..init(),
      builder: (context, _) {
        final pageState = context.select<MedicineViewModel, PageState>((vm) => vm.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else {
          return _loadView(context);
        }
      },
      child: _loadingView(),
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.medicinePageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.medicinePageTitle)),
      body: Center(
        child: _contentsView(context),
      ),
    );
  }

  Widget _contentsView(BuildContext context) {
    final viewModel = Provider.of<MedicineViewModel>(context);
    final medicine = viewModel.medicines;
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3 / 4,
      children: List.generate(
        medicine.length,
        (index) => MedicineCardView(medicine[index]),
      ),
    );
  }
}
