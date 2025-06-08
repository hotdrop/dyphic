import 'package:flutter/material.dart';

///
/// 画面の前面にプログレスインジケータを表示する
///
class AppProgressDialog<T> {
  const AppProgressDialog();

  Future<void> show(
    BuildContext context, {
    required Future<T> Function() execute,
    required Function(T) onSuccess,
    required Function(String) onError,
  }) async {
    _showProgressDialog(context);
    try {
      final navigator = Navigator.of(context);
      final result = await execute();
      navigator.pop();
      onSuccess(result);
    } on Exception catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      onError('$e');
    }
  }

  Future<void> _showProgressDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
