import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_page.dart';
import 'package:dyphic/ui/medicine/medicine_card_view.dart';
import 'package:dyphic/ui/medicine/medicine_view_model.dart';

class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicineViewModel>(
      create: (_) => MedicineViewModel.create()..init(),
      builder: (context, _) {
        final pageState = context.select<MedicineViewModel, PageState>((vm) => vm.pageState);
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
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.medicinePageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = Provider.of<MedicineViewModel>(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.medicinePageTitle)),
      body: _contentsView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int lastOrder = viewModel.getLastOrder();
          bool isUpdate = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => MedicineEditPage(Medicine.createEmpty(lastOrder)))) ?? false;
          AppLogger.i('戻り値: $isUpdate');
          if (isUpdate) {
            await viewModel.reload();
          }
        },
        child: Icon(Icons.add),
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
        (index) => MedicineCardView(
          medicine: medicine[index],
          onTapEvent: () async {
            bool isUpdate = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => MedicineEditPage(medicine[index]))) ?? false;
            AppLogger.i('戻り値: $isUpdate');
            if (isUpdate) {
              await viewModel.reload();
            }
          },
        ),
      ),
    );
  }
}
