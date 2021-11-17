import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/condition/condition_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionPage extends ConsumerWidget {
  const ConditionPage._();

  static Future<void> start(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const ConditionPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(conditionViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.conditionPageTitle),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: uiState.when(
          loading: (err) => _onLoading(context, err),
          success: () => _onSuccess(context, ref),
        ),
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errorMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMsg != null) {
        await AppDialog.onlyOk(message: errorMsg).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        _overview(context),
        _clearButton(ref),
        const Divider(),
        _conditionArea(ref),
        const Divider(),
        _inputArea(context, ref),
      ],
    );
  }

  Widget _overview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.conditionOverview),
          const SizedBox(height: 8),
          Text(AppStrings.conditionDetail, style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }

  Widget _clearButton(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: OutlinedButton(
            onPressed: () => ref.read(conditionViewModelProvider).clear(),
            child: const Text(AppStrings.conditionClearSelectedLabel),
          ),
        ),
      ],
    );
  }

  Widget _conditionArea(WidgetRef ref) {
    final conditions = ref.watch(conditionViewModelProvider).conditions;
    final selectName = ref.watch(conditionViewModelProvider).selectedConditionName;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 200,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.0,
        children: conditions
            .map(
              (c) => ChoiceChip(
                label: Text(c.name),
                selected: selectName == c.name,
                onSelected: (_) {
                  ref.read(conditionViewModelProvider).selectCondition(c);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _inputArea(BuildContext context, WidgetRef ref) {
    final isSigniIn = ref.watch(conditionViewModelProvider).isSignIn;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _textFieldOnInputArea(context, ref),
          const SizedBox(height: 16),
          if (isSigniIn) _saveButtonOnInputArea(context, ref),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _textFieldOnInputArea(BuildContext context, WidgetRef ref) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: ref.watch(conditionViewModelProvider).editController,
      decoration: const InputDecoration(
        labelText: AppStrings.conditionInputLabel,
        border: OutlineInputBorder(),
        filled: true,
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (String? inputVal) => ref.read(conditionViewModelProvider).inputValidator(inputVal),
      onFieldSubmitted: (String value) {
        ref.read(conditionViewModelProvider).input(value);
      },
    );
  }

  Widget _saveButtonOnInputArea(BuildContext context, WidgetRef ref) {
    final exist = ref.watch(conditionViewModelProvider).exist;
    String buttonName;
    if (exist) {
      buttonName = AppStrings.conditionEditButton;
    } else {
      buttonName = AppStrings.conditionNewButton;
    }

    final canSaved = ref.watch(conditionViewModelProvider).enableOnSave;
    return ElevatedButton(
      onPressed: canSaved ? () async => _processSave(context, ref) : null,
      child: Text(buttonName),
    );
  }

  Future<void> _processSave(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(conditionViewModelProvider).save,
      onSuccess: (_) async => await ref.read(conditionViewModelProvider).refresh(),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
