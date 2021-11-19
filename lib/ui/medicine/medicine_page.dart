import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_page.dart';
import 'package:dyphic/ui/medicine/medicine_card_view.dart';
import 'package:dyphic/ui/medicine/medicine_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicinePage extends ConsumerWidget {
  const MedicinePage._();

  static Future<void> start(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const MedicinePage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(medicineViewModelProvider).uiState;
    return uiState.when(
      loading: (err) => _onLoading(context, err),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, String? errorMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMsg != null) {
        await AppDialog.onlyOk(message: errorMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicinePageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isSigniIn = ref.watch(appSettingsProvider).isSignIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicinePageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: _viewContents(context, ref),
      ),
      floatingActionButton: isSigniIn
          ? FloatingActionButton(
              onPressed: () async => await _processAdd(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _processAdd(BuildContext context, WidgetRef ref) async {
    final newEmptyMeidine = ref.read(medicineProvider.notifier).createNew();
    bool isUpdate = await MedicineEditPage.start(context, newEmptyMeidine);
    AppLogger.d('戻り値: $isUpdate');
    if (isUpdate) {
      await ref.read(medicineViewModelProvider).reload();
    }
  }

  Widget _viewContents(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(medicineProvider);
    if (medicines.isEmpty) {
      return const Center(
        child: Text(AppStrings.medicinePageNothingItemLabel),
      );
    }

    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (BuildContext context, int index) {
        return MedicineCardView(
          medicine: medicines[index],
          isEditable: isSignIn,
          onTapEvent: () async {
            bool isUpdate = await MedicineEditPage.start(context, medicines[index]);
            AppLogger.d('戻り値: $isUpdate');
            if (isUpdate) {
              await ref.read(medicineViewModelProvider).reload();
            }
          },
        );
      },
    );
  }
}
