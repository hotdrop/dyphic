import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_page.dart';
import 'package:dyphic/ui/medicine/medicine_card_view.dart';
import 'package:dyphic/ui/medicine/medicine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.medicinePageTitle),
      ),
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = Provider.of<MedicineViewModel>(context);
    final isLogin = context.select<AppSettings, bool>((m) => m.isLogin);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.medicinePageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: _contentsView(context, isEditable: isLogin),
      ),
      floatingActionButton: isLogin
          ? FloatingActionButton(
              onPressed: () async {
                int newId = viewModel.createNewId();
                int newOrder = viewModel.createNewOrder();
                bool isUpdate = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => MedicineEditPage(Medicine.createEmpty(newId, newOrder))),
                    ) ??
                    false;
                AppLogger.d('戻り値: $isUpdate');
                if (isUpdate) {
                  await viewModel.reload();
                }
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _contentsView(BuildContext context, {required bool isEditable}) {
    final viewModel = Provider.of<MedicineViewModel>(context);
    final medicines = viewModel.medicines;
    if (medicines.isEmpty) {
      return Center(
        child: const Text(AppStrings.medicinePageNothingItemLabel),
      );
    } else {
      return ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (BuildContext context, int index) {
          return MedicineCardView(
            medicine: medicines[index],
            isEditable: isEditable,
            onTapEvent: () async {
              bool isUpdate =
                  await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => MedicineEditPage(medicines[index]))) ??
                      false;
              AppLogger.d('戻り値: $isUpdate');
              if (isUpdate) {
                await viewModel.reload();
              }
            },
          );
        },
      );
    }
  }
}
