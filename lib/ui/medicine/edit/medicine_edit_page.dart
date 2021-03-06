import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:dyphic/ui/medicine/edit/medicine_type_radio.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

class MedicineEditPage extends StatelessWidget {
  const MedicineEditPage(this._medicine);

  final Medicine _medicine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.medicineEditPageTitle)),
      body: ChangeNotifierProvider<MedicineEditViewModel>(
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
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 8.0),
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
        ],
      ),
    );
  }

  Widget _editFieldName(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return AppTextField.singleLine(
      label: AppStrings.medicineNameLabel,
      isRequired: true,
      initValue: _medicine.name,
      onChanged: (v) {
        viewModel.inputName(v);
      },
    );
  }

  Widget _editFieldOverview(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return AppTextField.singleLine(
      label: AppStrings.medicineOverviewLabel,
      isRequired: true,
      initValue: _medicine.overview,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.medicineMemoLabel),
        SizedBox(height: 4.0),
        AppTextField.multiLine(
          initValue: _medicine.memo,
          onChanged: (inputVal) {
            viewModel.inputMemo(inputVal);
          },
        )
      ],
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
            OutlineButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text(AppStrings.medicineStartCameraLabel),
              onPressed: () async {
                final imagePicker = ImagePicker();
                var image = await imagePicker.getImage(source: ImageSource.camera, imageQuality: 10);
                AppLogger.d('カメラ撮影しました。 path=${image.path}');
                if (image != null) {
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
    return RaisedButton(
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Text(
          AppStrings.medicineSaveButton,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (!viewModel.canSave) {
            AppSimpleDialog(message: AppStrings.medicineNotSaveAttention)..show(context);
            return;
          }
          final dialog = AppDialog.createInfo(
            title: AppStrings.medicineSaveDialogTitle,
            description: AppStrings.medicineSaveDialogDetail,
            successMessage: AppStrings.medicineSaveDialogSuccess,
            errorMessage: AppStrings.medicineSaveDialogError,
            onOkPress: viewModel.save,
            onSuccessOkPress: () {
              Navigator.pop(context, true);
            },
          );
          await dialog.show(context);
        });
  }
}
