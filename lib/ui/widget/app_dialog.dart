import 'dart:io';

import 'package:dyphic/res/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class AppDialog {
  const AppDialog._(
    this._title,
    this._message,
    this._okButtonLabel,
    this._onOk,
    this._cancelButtonLabel,
    this._onCancel,
    this._isShowCancelButton,
  );

  factory AppDialog.onlyOk({String? title, required String message, String? okLabel, Function? onOk}) {
    return AppDialog._(
      title,
      message,
      okLabel ?? AppStrings.dialogOk,
      onOk,
      AppStrings.dialogCancel,
      null,
      false,
    );
  }

  factory AppDialog.okAndCancel({String? title, required String message, String? okLabel, required Function onOk, String? cancelLabel, Function? onCancel}) {
    return AppDialog._(
      title,
      message,
      okLabel ?? AppStrings.dialogOk,
      onOk,
      cancelLabel ?? AppStrings.dialogCancel,
      onCancel,
      true,
    );
  }

  final String? _title;
  final String _message;
  final String _okButtonLabel;
  final Function? _onOk;
  final String _cancelButtonLabel;
  final Function? _onCancel;
  final bool _isShowCancelButton;

  Future<void> show(BuildContext context) async {
    if (Platform.isAndroid) {
      await _showMaterialDialog(context);
    } else {
      await _showCupertinoDialog(context);
    }
  }

  Future<void> _showMaterialDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _createMaterialDialog(context),
    );
  }

  Future<void> _showCupertinoDialog(BuildContext context) async {
    await cupertino.showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _createCupertinoDialog(context),
    );
  }

  AlertDialog _createMaterialDialog(BuildContext context) {
    return AlertDialog(
      title: _viewTitle(),
      content: Text(_message),
      actions: <Widget>[
        if (_isShowCancelButton)
          TextButton(
            onPressed: () => _onActionCancel(context),
            child: Text(_cancelButtonLabel),
          ),
        TextButton(
          onPressed: () => _onActionOk(context),
          child: Text(_okButtonLabel),
        ),
      ],
    );
  }

  Widget _createCupertinoDialog(BuildContext context) {
    return cupertino.CupertinoAlertDialog(
      title: _viewTitle(),
      content: Text(_message),
      actions: <Widget>[
        if (_isShowCancelButton)
          cupertino.CupertinoDialogAction(
            onPressed: () => _onActionCancel(context),
            child: Text(_cancelButtonLabel),
          ),
        cupertino.CupertinoDialogAction(
          onPressed: () => _onActionOk(context),
          child: Text(_okButtonLabel),
        ),
      ],
    );
  }

  Widget? _viewTitle() {
    return (_title != null) ? Text(_title!) : null;
  }

  void _onActionOk(BuildContext context) {
    Navigator.pop(context);
    _onOk?.call();
  }

  void _onActionCancel(BuildContext context) {
    Navigator.pop(context);
    _onCancel?.call();
  }
}
