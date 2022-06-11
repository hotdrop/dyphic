import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/medicine/edit/medicine_edit_page.dart';
import 'package:dyphic/ui/medicine/medicine_card_view.dart';
import 'package:dyphic/ui/medicine/medicine_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicinePage extends ConsumerWidget {
  const MedicinePage._();

  static Future<void> start(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const MedicinePage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(medicineViewModelProvider).uiState;
    return uiState.when(
      loading: (err) => _ViewLoading(errorMessage: err),
      success: () => const _ViewSuccess(),
    );
  }
}

class _ViewLoading extends StatelessWidget {
  const _ViewLoading({Key? key, this.errorMessage}) : super(key: key);

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMessage != null) {
        await AppDialog.onlyOk(message: errorMessage!).show(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicinePageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ViewSuccess extends ConsumerStatefulWidget {
  const _ViewSuccess({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ViewSuccessState();
}

class __ViewSuccessState extends ConsumerState<_ViewSuccess> {
  bool _visibleFab = true;

  @override
  Widget build(BuildContext context) {
    final isSigniIn = ref.watch(appSettingsProvider).isSignIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicinePageTitle),
        actions: const [_RefreshIcon()],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: ((notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() => _visibleFab = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() => _visibleFab = false);
          }
          return true;
        }),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 32.0),
          child: _ViewContents(),
        ),
      ),
      floatingActionButton: isSigniIn
          ? Visibility(
              visible: _visibleFab,
              child: const _MedicineAddFab(),
            )
          : null,
    );
  }
}

class _RefreshIcon extends ConsumerWidget {
  const _RefreshIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async => await _showRefreshDialog(context, ref),
      icon: const Icon(Icons.refresh),
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    AppDialog.okAndCancel(
      message: AppStrings.medicineRefreshConfirmMessage,
      onOk: () async => await _refresh(context, ref),
    ).show(context);
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(medicineViewModelProvider).refresh,
      onSuccess: (_) => {/* 成功時は何もしない */},
      onError: (err) => AppDialog.onlyOk(message: err).show(context),
    );
  }
}

class _MedicineAddFab extends ConsumerWidget {
  const _MedicineAddFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async => await _processAdd(context, ref),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _processAdd(BuildContext context, WidgetRef ref) async {
    final newEmptyMeidine = ref.read(medicineProvider.notifier).newMedicine();
    await MedicineEditPage.start(context, newEmptyMeidine);
  }
}

class _ViewContents extends ConsumerWidget {
  const _ViewContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(medicineProvider);
    if (medicines.isEmpty) {
      return const Center(
        child: Text(AppStrings.medicinePageNothingItemLabel),
      );
    }

    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (BuildContext context, int index) {
        return MedicineCardView(
          medicine: medicines[index],
          isEditable: isSignIn,
          onTapEvent: () async {
            await MedicineEditPage.start(context, medicines[index]);
          },
        );
      },
    );
  }
}
