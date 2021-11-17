import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/note/edit/note_edit_view_model.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteEditPage extends ConsumerWidget {
  const NoteEditPage._(this._note);

  static Future<bool> start(BuildContext context, Note note) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => NoteEditPage._(note)),
        ) ??
        false;
  }

  final Note _note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(noteEditViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.noteEditPageTitle),
      ),
      body: uiState.when(
        loading: (_) => _onLoading(context, ref),
        success: () => _onSuccess(context, ref),
      ),
    );
  }

  Widget _onLoading(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration.zero).then((_) async {
      ref.read(noteEditViewModelProvider).init(_note);
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(AppStrings.noteEditPageSelectIconLabel),
          _types(ref),
          const SizedBox(height: 8.0),
          _editTitle(ref),
          const SizedBox(height: 16.0),
          _editDetail(ref),
          const SizedBox(height: 8.0),
          _saveButton(context, ref),
        ],
      ),
    );
  }

  Widget _types(WidgetRef ref) {
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
              children: NoteType.values.map((type) => _typeRadio(ref, type)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeRadio(WidgetRef ref, NoteType noteType) {
    // TODO ここはwidgetに切り出した方がいい
    return Column(
      children: [
        NoteTypeIcon(noteType),
        Radio<int>(
          value: noteType.typeValue,
          groupValue: ref.read(noteEditViewModelProvider).inputTypeValue,
          onChanged: (int? value) {
            AppLogger.d('選択した値は $value');
            if (value != null) {
              ref.read(noteEditViewModelProvider).inputType(value);
            }
          },
        )
      ],
    );
  }

  Widget _editTitle(WidgetRef ref) {
    return AppTextField(
      label: AppStrings.noteEditPageLabelTitle,
      initValue: _note.title,
      isRequired: true,
      onChanged: (String v) {
        ref.read(noteEditViewModelProvider).inputTitle(v);
      },
    );
  }

  Widget _editDetail(WidgetRef ref) {
    return MultiLineTextField(
      label: AppStrings.noteEditPageLabelDetail,
      initValue: _note.detail,
      limitLine: 15,
      hintText: AppStrings.noteEditPageLabelDetailHint,
      onChanged: (String v) {
        ref.read(noteEditViewModelProvider).inputDetail(v);
      },
    );
  }

  Widget _saveButton(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(noteEditViewModelProvider).isSignIn;
    final canSaved = ref.watch(noteEditViewModelProvider).canSaved;
    return ElevatedButton(
      onPressed: (isSignIn && canSaved) ? () async => _processSave(context, ref) : null,
      child: const Text(AppStrings.noteEditPageSaveButton, style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _processSave(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const dialog = AppProgressDialog<void>();
    dialog.show(
      context,
      execute: ref.watch(noteEditViewModelProvider).save,
      onSuccess: (_) => Navigator.pop(context, true),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
