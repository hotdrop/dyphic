import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_controller.dart';
import 'package:dyphic/ui/medicine/widgets/medicine_type_radio.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:dyphic/ui/widget/app_text_field.dart';

class MedicineEditPage extends ConsumerWidget {
  const MedicineEditPage._(this.medicineId);

  static Future<bool> start(BuildContext context, int medicineId) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => MedicineEditPage._(medicineId)),
        ) ??
        false;
  }

  final int medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬情報'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ref.watch(medicineEditControllerProvider(medicineId)).when(
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

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: const [
          SizedBox(height: 16.0),
          _ViewEditFieldName(),
          SizedBox(height: 8.0),
          _ViewEditFieldOverview(),
          SizedBox(height: 8.0),
          _ViewSelectType(),
          SizedBox(height: 8.0),
          _ViewEditFieldMemo(),
          SizedBox(height: 8.0),
          _ViewSaveButton(),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _ViewEditFieldName extends ConsumerWidget {
  const _ViewEditFieldName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      label: 'お薬名',
      initValue: ref.read(medicineUiStateProvider).name,
      isRequired: true,
      onChanged: (String v) => ref.read(medicineEditMethodsProvider).inputName(v),
    );
  }
}

class _ViewEditFieldOverview extends ConsumerWidget {
  const _ViewEditFieldOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      label: '一言メモ',
      initValue: ref.read(medicineUiStateProvider).overview,
      isRequired: true,
      onChanged: (String v) => ref.read(medicineEditMethodsProvider).inputOverview(v),
    );
  }
}

class _ViewSelectType extends ConsumerWidget {
  const _ViewSelectType();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineTypeRadio(
      initSelectedType: ref.read(medicineUiStateProvider).type,
      onChange: (MedicineType t) => ref.read(medicineEditMethodsProvider).inputOral(t),
    );
  }
}

class _ViewEditFieldMemo extends ConsumerWidget {
  const _ViewEditFieldMemo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiLineTextField(
      label: '詳細メモ',
      initValue: ref.read(medicineUiStateProvider).memo,
      limitLine: 3,
      hintText: '詳細な情報を残したい場合はここに記載してください。',
      onChanged: (String v) => ref.read(medicineEditMethodsProvider).inputMemo(v),
    );
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => await _processSave(context, ref),
      child: const Text('この内容で保存する', style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _processSave(BuildContext context, WidgetRef ref) async {
    final canSave = ref.watch(canSaveMedicineEditStateProvider);
    if (!canSave) {
      AppDialog.onlyOk(message: 'お薬の名前が未入力です。').show(context);
      return;
    }

    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(medicineEditMethodsProvider).save,
      onSuccess: (_) => Navigator.pop(context, true),
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}
