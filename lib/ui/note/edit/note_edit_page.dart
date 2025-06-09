import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/note/edit/note_edit_controller.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

class NoteEditPage extends ConsumerWidget {
  const NoteEditPage._(this.noteId);

  static Future<void> start(BuildContext context, int noteId) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => NoteEditPage._(noteId)),
    );
  }

  final int noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ノート編集'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ref.watch(noteEditControllerProvider(noteId)).when(
              data: (_) => const _ViewBody(),
              error: (err, stackTrace) {
                return Center(
                  child: Text('$err', style: const TextStyle(color: Colors.red)),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
      ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text('イメージアイコンを選択してください'),
          _ViewTypes(),
          SizedBox(height: 8.0),
          _ViewEditTitleTextField(),
          SizedBox(height: 16.0),
          _ViewEditDetailTextField(),
          SizedBox(height: 8.0),
          _ViewSaveButton(),
        ],
      ),
    );
  }
}

class _ViewTypes extends ConsumerWidget {
  const _ViewTypes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectTypeValue = ref.watch(noteUiStateProvider).typeValue;
    return _TypeRadioGroup(
      selectedValue: selectTypeValue,
      onSelected: (int value) => ref.read(noteEditMethodsProvider).inputType(value),
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

class _ViewEditTitleTextField extends ConsumerWidget {
  const _ViewEditTitleTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(noteUiStateProvider).title;
    return AppTextField(
      label: 'タイトル',
      initValue: title,
      isRequired: true,
      onChanged: (String v) => ref.read(noteEditMethodsProvider).inputTitle(v),
    );
  }
}

class _ViewEditDetailTextField extends ConsumerWidget {
  const _ViewEditDetailTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(noteUiStateProvider).detail;
    return MultiLineTextField(
      label: '詳細',
      initValue: detail,
      limitLine: 15,
      hintText: 'ここに詳細メモを記載してください。',
      onChanged: (String v) => ref.read(noteEditMethodsProvider).inputDetail(v),
    );
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSaved = ref.watch(canSaveNoteEditStateProvider);
    return ElevatedButton(
      onPressed: canSaved ? () async => await _processSave(context, ref) : null,
      child: const Text('この内容で保存する', style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _processSave(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.watch(noteEditMethodsProvider).save,
      onSuccess: (_) => Navigator.pop(context),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
