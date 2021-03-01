import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:dyphic/common/app_strings.dart';

class AppDialog {
  const AppDialog._(
    this._type,
    this._title,
    this._description,
    this._successMessage,
    this._errorMessage,
    this._onOkPress,
    this._onCancelPress,
    this._onSuccessOkPress,
  );

  factory AppDialog.createInfo({
    @required String title,
    @required String description,
    @required String successMessage,
    @required String errorMessage,
    @required Future<bool> Function() onOkPress,
    void Function() onCancelPress,
    void Function() onSuccessOkPress,
  }) {
    return AppDialog._(
      DialogType.INFO,
      title,
      description,
      successMessage,
      errorMessage,
      onOkPress,
      onCancelPress,
      onSuccessOkPress,
    );
  }

  final DialogType _type;
  final String _title;
  final String _description;
  final String _successMessage;
  final String _errorMessage;
  final Future<bool> Function() _onOkPress;
  final void Function() _onCancelPress;
  final void Function() _onSuccessOkPress;

  Future<void> show(BuildContext context) async {
    return AwesomeDialog(
      context: context,
      dialogType: _type,
      title: _title,
      desc: _description,
      btnCancelOnPress: (_onCancelPress != null) ? _onCancelPress : () {},
      btnOkOnPress: () async {
        await _showDialog(context);
      },
    ).show();
  }

  Future<void> _showDialog(BuildContext context) async {
    final progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    await progressDialog.show();
    final isSuccess = await _onOkPress();
    await progressDialog.hide();

    if (isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        title: AppStrings.dialogTitleSuccess,
        desc: _successMessage,
        btnOkOnPress: (_onSuccessOkPress != null) ? () => _onSuccessOkPress() : () {},
      ).show();
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: AppStrings.dialogTitleError,
        desc: _errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }
}

///
/// OKのみの確認ダイアログ
///
class AppSimpleDialog {
  const AppSimpleDialog({@required this.message});

  final String message;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text(AppStrings.dialogOkLabel),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

///
/// 文字列入力フィールド付きのダイアログ
///
class TextEditDialog extends StatefulWidget {
  const TextEditDialog({
    @required this.title,
    @required this.initValue,
  });

  final String title;
  final String initValue;

  @override
  _TextEditDialogState createState() => _TextEditDialogState();
}

class _TextEditDialogState extends State<TextEditDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextFormField(
        autofocus: true,
        controller: _controller,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppStrings.dialogCancelLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppStrings.dialogOkLabel),
          onPressed: () {
            Navigator.pop<String>(context, _controller.text);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

///
/// 体温入力フィールド付きのダイアログ
///
class TemperatureEditDialog extends StatefulWidget {
  const TemperatureEditDialog({
    @required this.title,
    @required this.initValue,
  });

  final String title;
  final double initValue;

  @override
  _TemperatureEditDialogState createState() => _TemperatureEditDialogState();
}

class _TemperatureEditDialogState extends State<TemperatureEditDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextFormField(
        keyboardType: TextInputType.number,
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
          hintText: AppStrings.recordTemperatureTextHint,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppStrings.dialogCancelLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppStrings.dialogOkLabel),
          onPressed: () {
            final inputValue = double.parse(_controller.text);
            Navigator.pop<double>(context, inputValue);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
