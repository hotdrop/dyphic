import 'package:dyphic/res/app_strings.dart';
import 'package:flutter/material.dart';

class AppDialog {
  const AppDialog._(
    this._title,
    this._message,
    this._onOk,
    this._onCancel,
    this._isShowCancelButton,
  );

  factory AppDialog.onlyOk({String? title, required String message, Function? onOk}) {
    return AppDialog._(title, message, onOk, null, false);
  }

  factory AppDialog.okAndCancel({String? title, required String message, required Function onOk, Function? onCancel}) {
    return AppDialog._(title, message, onOk, onCancel, true);
  }

  final String? _title;
  final String _message;
  final Function? _onOk;
  final Function? _onCancel;
  final bool _isShowCancelButton;

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _createMaterialDialog(context),
    );
  }

  AlertDialog _createMaterialDialog(BuildContext context) {
    return AlertDialog(
      title: _viewTitle(),
      content: Text(_message),
      actions: <Widget>[
        if (_isShowCancelButton)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onCancel?.call();
            },
            child: const Text(AppStrings.dialogCancel),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _onOk?.call();
          },
          child: const Text(AppStrings.dialogOk),
        ),
      ],
    );
  }

  Widget? _viewTitle() {
    return (_title != null) ? Text(_title!) : null;
  }
}
