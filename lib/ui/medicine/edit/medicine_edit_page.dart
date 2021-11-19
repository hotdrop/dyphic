import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_view_model.dart';
import 'package:dyphic/ui/medicine/edit/widget_medicine_type_radio.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:image_picker/image_picker.dart';

class MedicineEditPage extends ConsumerWidget {
  const MedicineEditPage._(this._medicine);

  static Future<bool> start(BuildContext context, Medicine m) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => MedicineEditPage._(m)),
        ) ??
        false;
  }

  final Medicine _medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(medicineEditViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicineEditPageTitle),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: uiState.when(
          loading: (_) => _onLoading(context, ref),
          success: () => _onSuccess(context, ref),
        ),
      ),
    );
  }

  Widget _onLoading(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration.zero).then((_) async {
      ref.read(medicineEditViewModelProvider).init(_medicine);
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 16.0),
          _editFieldName(context, ref),
          const SizedBox(height: 8.0),
          _editFieldOverview(context, ref),
          const SizedBox(height: 8.0),
          _selectType(context, ref),
          _selectImageView(context, ref),
          const SizedBox(height: 8.0),
          _editFieldMemo(context, ref),
          const SizedBox(height: 8.0),
          _saveButton(context, ref),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _editFieldName(BuildContext context, WidgetRef ref) {
    return AppTextField(
      label: AppStrings.medicineNameLabel,
      initValue: _medicine.name,
      isRequired: true,
      onChanged: (String v) => ref.read(medicineEditViewModelProvider).inputName(v),
    );
  }

  Widget _editFieldOverview(BuildContext context, WidgetRef ref) {
    return AppTextField(
      label: AppStrings.medicineOverviewLabel,
      initValue: _medicine.overview,
      isRequired: true,
      onChanged: (String v) => ref.read(medicineEditViewModelProvider).inputOverview(v),
    );
  }

  Widget _selectType(BuildContext context, WidgetRef ref) {
    return MedicineTypeRadio(
      initSelectedType: _medicine.type,
      onChange: (MedicineType t) => ref.read(medicineEditViewModelProvider).inputOral(t),
    );
  }

  Widget _editFieldMemo(BuildContext context, WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.medicineMemoLabel,
      initValue: _medicine.memo,
      limitLine: 3,
      hintText: AppStrings.medicineMemoHint,
      onChanged: (String v) => ref.read(medicineEditViewModelProvider).inputMemo(v),
    );
  }

  Widget _selectImageView(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(medicineEditViewModelProvider).imageFilePath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: AppImage.large(path: imagePath),
        ),
        Text(AppStrings.medicineImageOverviewLabel, style: Theme.of(context).textTheme.caption),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text(AppStrings.medicineStartCameraLabel),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 10);
                if (image != null) {
                  AppLogger.d('カメラ撮影しました。 path=${image.path}');
                  ref.read(medicineEditViewModelProvider).inputImagePath(image.path);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => await _processSave(context, ref),
      child: const Text(AppStrings.medicineSaveButton, style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _processSave(BuildContext context, WidgetRef ref) async {
    final canSave = ref.watch(medicineEditViewModelProvider).canSave;
    if (!canSave) {
      AppDialog.onlyOk(message: AppStrings.medicineNotSaveAttention).show(context);
      return;
    }

    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(medicineEditViewModelProvider).save,
      onSuccess: (_) => Navigator.pop(context, true),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
