import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/note/edit/note_edit_view_model.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

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
    return _TypeRadioGroup(
      selectedValue: _note.typeValue,
      onSelected: (int value) {
        ref.read(noteEditViewModelProvider).inputType(value);
      },
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
    final canSaved = ref.watch(noteEditViewModelProvider).canSaved;
    return ElevatedButton(
      onPressed: canSaved ? () async => _processSave(context, ref) : null,
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

///
/// ノートのタイプ別アイコン
/// ラジオボタンでいずれか1つを選択する
///
class _TypeRadioGroup extends StatefulWidget {
  const _TypeRadioGroup({required this.selectedValue, required this.onSelected});

  final int selectedValue;
  final Function(int) onSelected;

  @override
  State<StatefulWidget> createState() => _TypeRadioGroupState();
}

class _TypeRadioGroupState extends State<_TypeRadioGroup> {
  int _selectedValue = 0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            spacing: 16.0,
            runSpacing: 8.0,
            children: NoteType.values.map((type) => _typeItem(type)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _typeItem(NoteType type) {
    return Column(
      children: [
        NoteTypeIcon(type),
        Radio<int>(
          value: type.typeValue,
          groupValue: _selectedValue,
          onChanged: (int? value) {
            if (value != null) {
              setState(() => _selectedValue = value);
              widget.onSelected(value);
            }
          },
        )
      ],
    );
  }
}
