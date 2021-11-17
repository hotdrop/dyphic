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
      final result = await execute();
      _closeDialog(context);
      onSuccess(result);
    } on Exception catch (e) {
      _closeDialog(context);
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

  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
