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
      create: (_) => MedicineViewModel.create(),
      builder: (context, _) {
        final pageState = context.select<MedicineViewModel, PageLoadingState>((vm) => vm.pageState);
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
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.medicinePageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = Provider.of<MedicineViewModel>(context);
    if (viewModel.isLogin) {
      return _rootViewAllowRegister(context);
    } else {
      return _rootViewDeniedRegister(context);
    }
  }

  Widget _rootViewDeniedRegister(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.medicinePageTitle)),
      body: _contentsView(context),
    );
  }

  Widget _rootViewAllowRegister(BuildContext context) {
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
    final medicines = viewModel.medicines;
    if (medicines.isEmpty) {
      return Center(
        child: Text(AppStrings.medicinePageNothingItemLabel),
      );
    } else {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index < medicines.length) {
            return MedicineCardView(
              medicine: medicines[index],
              isEditPermission: viewModel.isLogin,
              onTapEvent: () async {
                bool isUpdate = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => MedicineEditPage(medicines[index]))) ?? false;
                AppLogger.i('戻り値: $isUpdate');
                if (isUpdate) {
                  await viewModel.reload();
                }
              },
            );
          }
          return null;
        },
      );
    }
  }
}
