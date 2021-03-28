import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_view_model.dart';
import 'package:dyphic/ui/medicine/edit/widget_medicine_type_radio.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_simple_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MedicineEditPage extends StatelessWidget {
  const MedicineEditPage(this._medicine);

  final Medicine _medicine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.medicineEditPageTitle)),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ChangeNotifierProvider<MedicineEditViewModel>(
          create: (_) => MedicineEditViewModel.create(_medicine),
          builder: (context, _) {
            final pageState = context.select<MedicineEditViewModel, PageLoadingState>((vm) => vm.pageState);
            if (pageState.isLoadSuccess) {
              return _loadSuccessView(context);
            } else {
              return _nowLoadingView();
            }
          },
          child: _nowLoadingView(),
        ),
      ),
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 16.0),
          _editFieldName(context),
          const SizedBox(height: 8.0),
          _editFieldOverview(context),
          const SizedBox(height: 8.0),
          _selectType(context),
          _selectImageView(context),
          const SizedBox(height: 8.0),
          _editFieldMemo(context),
          const SizedBox(height: 8.0),
          _saveButton(context),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _editFieldName(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return AppTextField(
      label: AppStrings.medicineNameLabel,
      initValue: _medicine.name,
      isRequired: true,
      onChanged: (String v) {
        viewModel.inputName(v);
      },
    );
  }

  Widget _editFieldOverview(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return AppTextField(
      label: AppStrings.medicineOverviewLabel,
      initValue: _medicine.overview,
      isRequired: true,
      onChanged: (v) {
        viewModel.inputOverview(v);
      },
    );
  }

  Widget _selectType(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return MedicineTypeRadio(
        initSelectedType: _medicine.type,
        onChange: (v) {
          viewModel.inputOral(v);
        });
  }

  Widget _editFieldMemo(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return MultiLineTextField(
      label: AppStrings.medicineMemoLabel,
      initValue: _medicine.memo,
      limitLine: 3,
      hintText: AppStrings.medicineMemoHint,
      onChanged: viewModel.inputMemo,
    );
  }

  Widget _selectImageView(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    AppLogger.d('読み込んだ画像path=${viewModel.imageFilePath}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: AppImage.large(path: viewModel.imageFilePath),
        ),
        Text(AppStrings.medicineImageOverviewLabel, style: Theme.of(context).textTheme.caption),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: Text(AppStrings.medicineStartCameraLabel),
              onPressed: () async {
                final imagePicker = ImagePicker();
                PickedFile? image = await imagePicker.getImage(source: ImageSource.camera, imageQuality: 10);
                if (image != null) {
                  AppLogger.d('カメラ撮影しました。 path=${image.path}');
                  viewModel.inputImagePath(image.path);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onPressed: () async {
        if (!viewModel.canSave) {
          AppDialog.ok(message: AppStrings.medicineNotSaveAttention).show(context);
          return;
        }

        bool? isSuccess = await AppProgressDialog(execute: viewModel.save).show(context);
        if (isSuccess) {
          Navigator.pop(context, isSuccess);
        }
      },
      child: const Text(AppStrings.medicineSaveButton, style: TextStyle(color: Colors.white)),
    );
  }
}
