import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

class MemoArea extends ConsumerStatefulWidget {
  const MemoArea(this.id, this.currentMemo, {Key? key}) : super(key: key);

  final int id;
  final String? currentMemo;

  @override
  ConsumerState<MemoArea> createState() => _MemoAreaState();
}

class _MemoAreaState extends ConsumerState<MemoArea> {
  String _inputMemo = '';

  @override
  void initState() {
    super.initState();
    _inputMemo = widget.currentMemo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MultiLineTextField(
              label: AppStrings.recordMemoTitle,
              initValue: _inputMemo,
              limitLine: 10,
              hintText: AppStrings.recordMemoHint,
              onChanged: (String? input) {
                _inputMemo = input ?? '';
              },
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: ref.watch(appSettingsProvider).isSignIn ? () async => await _saveMemo(context, ref) : null,
              child: const Text(AppStrings.recordMemoSaveButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMemo(BuildContext context, WidgetRef ref) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveMemo(id: widget.id, memo: _inputMemo);
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
