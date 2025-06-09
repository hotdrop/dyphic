import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/ui/condition/condition_controller.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';

class ConditionPage extends ConsumerWidget {
  const ConditionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(conditionControllerProvider).when(
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
        );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigniIn = ref.watch(isSignInProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('体調'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _ViewOverview(),
            const _ViewClearButton(),
            const Divider(),
            const _ViewConditionArea(),
            const Divider(),
            const SizedBox(height: 16),
            const _ViewInputTextField(),
            const _ViewSameNameErrorLabel(),
            const SizedBox(height: 36),
            if (isSigniIn) const _ViewSaveButton(),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _ViewOverview extends StatelessWidget {
  const _ViewOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('この画面では体調に関する症状を登録・編集できます。'),
        const SizedBox(height: 8),
        Text(
          '「頭痛」や「腹痛」など大まかな症状を登録し、細かい症状は日々の記録画面にある体調メモに書いていくことをオススメします。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ViewClearButton extends ConsumerWidget {
  const _ViewClearButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8),
          child: OutlinedButton(
            onPressed: () => ref.read(conditionControllerProvider.notifier).clear(),
            child: const Text('選択をクリアする'),
          ),
        ),
      ],
    );
  }
}

class _ViewConditionArea extends ConsumerWidget {
  const _ViewConditionArea();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(conditionUiStateProvider);
    final selectName = uiState.getSelectName();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 200,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.0,
        children: uiState.conditions.map((c) {
          return ChoiceChip(
            label: Text(c.name),
            selected: selectName == c.name,
            onSelected: (_) => ref.read(conditionControllerProvider.notifier).selectCondition(c),
          );
        }).toList(),
      ),
    );
  }
}

class _ViewInputTextField extends ConsumerWidget {
  const _ViewInputTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: ref.watch(conditionNameEditController),
      decoration: const InputDecoration(
        labelText: '症状名',
        border: OutlineInputBorder(),
        filled: true,
      ),
      onFieldSubmitted: (String newVal) {
        ref.read(conditionControllerProvider.notifier).inputName(newVal);
      },
      autovalidateMode: AutovalidateMode.always,
    );
  }
}

class _ViewSameNameErrorLabel extends ConsumerWidget {
  const _ViewSameNameErrorLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDuplicate = ref.watch(conditionNameDuplicateProvider);
    if (isDuplicate) {
      return const Text(
        '同名の症状がすでに登録されています',
        style: TextStyle(color: Colors.red),
      );
    } else {
      return const Text(
        '入力したら必ずEnterを押してください',
        style: TextStyle(color: Colors.blueAccent),
      );
    }
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(conditionUiStateProvider);
    final buttonName = uiState.isSelected() ? '症状名を修正する' : '新しく登録する';
    final canSaved = ref.watch(enableSaveConditionProvider);

    return ElevatedButton(
      onPressed: canSaved ? () async => await _save(context, ref) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(buttonName),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(conditionControllerProvider.notifier).save,
      onSuccess: (_) => ref.read(conditionControllerProvider.notifier).clear(),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
