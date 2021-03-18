import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/note/edit/note_edit_view_model.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage(this._note);

  final Note _note;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteEditViewModel>(
      create: (_) => NoteEditViewModel.create(_note),
      builder: (context, _) {
        final pageState = context.select<NoteEditViewModel, PageLoadingState>((vm) => vm.pageState);
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
        title: const Text(AppStrings.noteEditPageTitle),
      ),
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.noteEditPageTitle),
      ),
      body: _contentsView(context),
    );
  }

  Widget _contentsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('イメージアイコンを選択してください'),
          _types(context),
          const SizedBox(height: 8.0),
          _editTitle(context),
          const SizedBox(height: 16.0),
          _editDetail(context),
          const SizedBox(height: 8.0),
          _saveButton(context),
        ],
      ),
    );
  }

  Widget _types(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              spacing: 16.0,
              runSpacing: 8.0,
              children: NoteType.values.map((type) => _typeRadio(context, type)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeRadio(BuildContext context, NoteType noteType) {
    final viewModel = Provider.of<NoteEditViewModel>(context);
    return Column(
      children: [
        NoteTypeIcon(noteType),
        Radio<int>(
          value: noteType.typeValue,
          groupValue: viewModel.inputTypeValue,
          onChanged: (int? value) {
            AppLogger.d('選択した値は $value');
            if (value != null) {
              viewModel.inputType(value);
            }
          },
        )
      ],
    );
  }

  Widget _editTitle(BuildContext context) {
    final viewModel = Provider.of<NoteEditViewModel>(context);
    return AppTextField(
      label: AppStrings.noteEditPageLabelTitle,
      initValue: _note.title,
      isRequired: true,
      onChanged: (String v) {
        viewModel.inputTitle(v);
      },
    );
  }

  Widget _editDetail(BuildContext context) {
    final viewModel = Provider.of<NoteEditViewModel>(context);
    return MultiLineTextField(
      label: AppStrings.noteEditPageLabelDetail,
      initValue: _note.detail,
      limitLine: 15,
      hintText: AppStrings.noteEditPageLabelDetailHint,
      onChanged: (String v) {
        viewModel.inputDetail(v);
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    final viewModel = Provider.of<NoteEditViewModel>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onPressed: viewModel.canSave
          ? () async {
              // キーボードが出ている場合は閉じる
              FocusScope.of(context).unfocus();
              bool? isSuccess = await showDialog<bool>(
                      context: context,
                      builder: (_) {
                        return AppProgressDialog(
                          execute: viewModel.save,
                          onSuccess: (bool isSuccess) => Navigator.pop(context, isSuccess),
                        );
                      }) ??
                  false;
              if (isSuccess) {
                Navigator.pop(context, isSuccess);
              }
            }
          : null,
      child: const Text(
        AppStrings.noteEditPageSaveButton,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
