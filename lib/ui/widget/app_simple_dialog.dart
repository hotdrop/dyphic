import 'package:flutter/material.dart';

import 'package:dyphic/common/app_strings.dart';

class AppDialog {
  const AppDialog._(this._message, this._onTapOk, this._onTapCancel);

  factory AppDialog.ok({
    required String message,
    VoidCallback? onOk,
  }) {
    return AppDialog._(message, onOk, null);
  }

  factory AppDialog.okAndCancel({
    required String message,
    required VoidCallback onOk,
    VoidCallback? onCancel,
  }) {
    if (onCancel == null) {
      return AppDialog._(message, onOk, () {});
    } else {
      return AppDialog._(message, onOk, onCancel);
    }
  }

  final String _message;
  final VoidCallback? _onTapOk;
  final VoidCallback? _onTapCancel;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        if (_onTapCancel != null) {
          return _createOkAndCancel(context, _onTapCancel!);
        } else {
          return _createOkOnly(context);
        }
      },
    );
  }

  AlertDialog _createOkOnly(BuildContext context) {
    return AlertDialog(
      content: Text(_message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (_onTapOk != null) {
              _onTapOk!();
            }
            Navigator.pop(context);
          },
          child: const Text(AppStrings.dialogOk),
        ),
      ],
    );
  }

  AlertDialog _createOkAndCancel(BuildContext context, VoidCallback onCancel) {
    return AlertDialog(
      content: Text(_message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel();
            Navigator.pop(context);
          },
          child: const Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: () {
            if (_onTapOk != null) {
              _onTapOk!();
            }
            Navigator.pop(context);
          },
          child: const Text(AppStrings.dialogOk),
        ),
      ],
    );
  }
}
