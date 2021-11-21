import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/calender/record/contents_title.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';

class MedicineArea extends ConsumerStatefulWidget {
  const MedicineArea(this.id, this.currentSelectMedicines, {Key? key}) : super(key: key);

  final int id;
  final List<Medicine> currentSelectMedicines;

  @override
  ConsumerState<MedicineArea> createState() => _MedicineAreaState();
}

class _MedicineAreaState extends ConsumerState<MedicineArea> {
  Set<int> _selectMedicineIds = {};

  @override
  void initState() {
    super.initState();
    _selectMedicineIds = widget.currentSelectMedicines.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _viewTitle(),
            const Divider(),
            _viewSelectChips(),
            _viewSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle() {
    return ContentsTitle(
      title: AppStrings.recordMedicalTitle,
      appIcon: AppIcon.medicine(),
    );
  }

  Widget _viewSelectChips() {
    return MedicineSelectChips(
      selectIds: _selectMedicineIds,
      onChanged: (Set<int> ids) {
        AppLogger.d('選択しているお薬は $ids です');
        _selectMedicineIds = ids;
      },
    );
  }

  Widget _viewSaveButton(BuildContext context) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveMedicine(context) : null,
      child: const Text(AppStrings.recordMedicineSaveButton),
    );
  }

  Future<void> _processSaveMedicine(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveMedicine(
              id: widget.id,
              medicineIds: _selectMedicineIds,
            );
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
