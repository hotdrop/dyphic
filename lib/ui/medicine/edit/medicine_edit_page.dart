import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_image.dart';
import 'package:dyphic/ui/widget/app_radio.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MedicineEditPage extends StatelessWidget {
  const MedicineEditPage(this._medicine);

  final Medicine _medicine;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicineEditViewModel>(
      create: (_) => MedicineEditViewModel.create()..init(_medicine),
      builder: (context, _) {
        final pageState = context.select<MedicineEditViewModel, PageLoadingState>((vm) => vm.pageState);
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
    final title = _medicine.name.isEmpty ? AppStrings.medicineRegisterPageTitle : AppStrings.medicineEditPageTitle;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: _contentsView(context),
    );
  }

  Widget _contentsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 8.0),
          _editNameView(context),
          const SizedBox(height: 8.0),
          _switchOralView(context),
          _selectImageView(context),
          const SizedBox(height: 8.0),
          _editMemoView(context),
          const SizedBox(height: 8.0),
          _saveButton(context),
        ],
      ),
    );
  }

  Widget _editNameView(BuildContext context) {
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

  Widget _switchOralView(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return AppRadio(
        initSelectedOral: _medicine.isOral,
        onChange: (v) {
          viewModel.inputOral(v);
        });
  }

  Widget _editMemoView(BuildContext context) {
    final viewModel = Provider.of<MedicineEditViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.medicineMemoLabel),
        SizedBox(
          height: 8.0,
        ),
        Text(AppStrings.medicineMemoAttentionLabel, style: Theme.of(context).textTheme.caption),
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
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          // TODO AppImageはネットワークの画像も考慮しないとダメ
          child: AppImage(path: viewModel.imageFilePath),
        ),
        Text(AppStrings.medicineImageOverviewLabel),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlineButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text(AppStrings.medicineStartCameraLabel),
                onPressed: () async {
                  final imagePicker = ImagePicker();
                  var image = await imagePicker.getImage(source: ImageSource.camera);
                  AppLogger.d('カメラ撮影しました。 path=${image.path}');
                  if (image != null) {
                    viewModel.inputImagePath(image.path);
                  }
                }),
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
            title: AppStrings.medicineSaveButton,
            description: AppStrings.medicineSaveAttention,
            successMessage: AppStrings.medicineSaveSuccess,
            errorMessage: viewModel.errorMessage,
            onOkPress: viewModel.save,
            onSuccessOkPress: () {
              Navigator.pop(context, true);
            },
          );
          await dialog.show(context);
        });
  }
}
