import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/service/firebase_auth.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_page.dart';
import 'package:dyphic/ui/medicine/widgets/medicine_card_view.dart';
import 'package:dyphic/ui/medicine/medicine_controller.dart';

class MedicinePage extends ConsumerWidget {
  const MedicinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(medicineControllerProvider).when(
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
    final isSignIn = ref.watch(firebaseAuthProvider).isSignIn;
    final isShowFab = ref.watch(isShowFabStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬'),
        actions: const [_RefreshIcon()],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: ((notification) {
          if (notification.direction == ScrollDirection.forward) {
            ref.read(isShowFabStateProvider.notifier).state = true;
          } else if (notification.direction == ScrollDirection.reverse) {
            ref.read(isShowFabStateProvider.notifier).state = false;
          }
          return true;
        }),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 32.0),
          child: _ViewContents(),
        ),
      ),
      floatingActionButton: isSignIn
          ? Visibility(
              visible: isShowFab,
              child: const _MedicineAddFab(),
            )
          : null,
    );
  }
}

class _RefreshIcon extends ConsumerWidget {
  const _RefreshIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async => await _showRefreshDialog(context, ref),
      icon: const Icon(Icons.refresh),
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    AppDialog.okAndCancel(
      message: 'サーバーから最新のお薬情報を取得します。\nよろしいですか？',
      onOk: () async => await _refresh(context, ref),
    ).show(context);
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(medicineControllerProvider.notifier).refresh,
      onSuccess: (_) => {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _MedicineAddFab extends ConsumerWidget {
  const _MedicineAddFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async => await _processAdd(context, ref),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _processAdd(BuildContext context, WidgetRef ref) async {
    final newId = ref.read(medicineControllerProvider.notifier).createNewId();
    final isUpdate = await MedicineEditPage.start(context, newId);
    if (isUpdate) {
      ref.read(medicineControllerProvider.notifier).onLoad();
    }
  }
}

class _ViewContents extends ConsumerWidget {
  const _ViewContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(medicineUiStateProvider);
    if (medicines.isEmpty) {
      return const Center(
        child: Text('お薬が登録されていません。\nログインしてお薬を登録しましょう。'),
      );
    }

    final isSignIn = ref.watch(firebaseAuthProvider).isSignIn;
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (BuildContext context, int index) {
        return MedicineCardView(
          medicine: medicines[index],
          isEditable: isSignIn,
          onTapEvent: () async {
            final isUpdate = await MedicineEditPage.start(context, medicines[index].id);
            if (isUpdate) {
              ref.read(medicineControllerProvider.notifier).onLoad();
            }
          },
        );
      },
    );
  }
}
