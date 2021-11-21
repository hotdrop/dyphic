import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/calender/record/contents_title.dart';
import 'package:dyphic/ui/calender/record/record_view_model.dart';
import 'package:dyphic/ui/widget/app_check_box.dart';
import 'package:dyphic/ui/widget/app_chips.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_icon.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

class ConditionArea extends ConsumerStatefulWidget {
  const ConditionArea(this.record, {Key? key}) : super(key: key);

  final Record record;

  @override
  ConsumerState<ConditionArea> createState() => _ConditionAreaState();
}

///
/// 体調情報の編集エリア
///
class _ConditionAreaState extends ConsumerState<ConditionArea> {
  Set<int> _selectConditionIds = {};
  bool _inputIsWalking = false;
  bool _inputIsToilet = false;
  String _inputMemo = '';

  @override
  void initState() {
    super.initState();
    _selectConditionIds = widget.record.conditions.map((e) => e.id).toSet();
    _inputIsWalking = widget.record.isWalking;
    _inputIsToilet = widget.record.isToilet;
    _inputMemo = widget.record.conditionMemo ?? '';
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
            const Divider(),
            _viewCheckBoxes(),
            _viewMemo(),
            const SizedBox(height: 8.0),
            _viewSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _viewTitle() {
    return ContentsTitle(
      title: AppStrings.recordConditionTitle,
      appIcon: AppIcon.condition(),
    );
  }

  Widget _viewSelectChips() {
    return ConditionSelectChips(
      selectIds: _selectConditionIds,
      onChange: (Set<int> ids) {
        AppLogger.d('選択している症状は $ids です');
        _selectConditionIds = ids;
      },
    );
  }

  Widget _viewCheckBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: _inputIsWalking,
          onChanged: (bool? isCheck) {
            AppLogger.d('歩いたチェック: $isCheck');
            _inputIsWalking = isCheck ?? false;
          },
        ),
        AppCheckBox.toilet(
          initValue: _inputIsToilet,
          onChanged: (bool? isCheck) {
            AppLogger.d('トイレチェック: $isCheck');
            _inputIsToilet = isCheck ?? false;
          },
        ),
      ],
    );
  }

  Widget _viewMemo() {
    return MultiLineTextField(
      label: AppStrings.recordConditionMemoTitle,
      initValue: _inputMemo,
      limitLine: 10,
      hintText: AppStrings.recordConditionMemoHint,
      onChanged: (String? input) {
        _inputMemo = input ?? '';
      },
    );
  }

  Widget _viewSaveButton(BuildContext context) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return OutlinedButton(
      onPressed: isSignIn ? () async => await _processSaveCondition(context) : null,
      child: const Text(AppStrings.recordConditionSaveButton),
    );
  }

  Future<void> _processSaveCondition(BuildContext context) async {
    // キーボードが出ている場合は閉じる
    FocusScope.of(context).unfocus();
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: () async {
        await ref.read(recordViewModelProvider).saveCondition(
              id: widget.record.id,
              conditionIds: _selectConditionIds,
              isWalking: _inputIsWalking,
              isToilet: _inputIsToilet,
              memo: _inputMemo,
            );
      },
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
