import 'package:dyphic/ui/top_page.dart';
import 'package:dyphic/ui/start/splash_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(splashViewModelProvider).uiState;
    return Scaffold(
      body: uiState.when(
        loading: (String? errorMsg) => _onLoading(context, errorMsg),
        success: () => _onSuccess(context),
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

  Widget _onSuccess(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      await TopPage.start(context);
    });
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
