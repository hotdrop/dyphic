import 'package:flutter/material.dart';

import 'package:dyphic/common/app_strings.dart';

class AppProgressDialog extends StatefulWidget {
  const AppProgressDialog({
    required this.execute,
    required this.onSuccess,
  });

  final Future<bool> Function() execute;
  final Function(bool) onSuccess;

  @override
  State<StatefulWidget> createState() => _AppProgressDialogState();
}

class _AppProgressDialogState extends State<AppProgressDialog> {
  _ExecState _state = _ExecState.loading;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero).then((_) async {
      bool result = await widget.execute();
      if (result) {
        setState(() {
          _state = _ExecState.success;
        });
      } else {
        setState(() {
          _state = _ExecState.error;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _ExecState.success:
        return _dialogLoadSuccess(context);
      case _ExecState.error:
        return _dialogLoadError();
      default:
        return _dialogLoading();
    }
  }

  Dialog _dialogLoading() {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Dialog _dialogLoadSuccess(BuildContext context) {
    return _createDialog(
      message: AppStrings.dialogSuccessMessage,
      iconData: Icons.check_circle,
      messageColor: Colors.blue,
      result: true,
    );
  }

  Dialog _dialogLoadError() {
    return _createDialog(
      message: AppStrings.dialogErrorMessage,
      iconData: Icons.error,
      messageColor: Colors.red,
      result: false,
    );
  }

  Dialog _createDialog({
    required String message,
    required Color messageColor,
    required IconData iconData,
    required bool result,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            margin: EdgeInsets.only(top: 30.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(color: Colors.black, offset: Offset(0, 4), blurRadius: 4),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: TextStyle(color: messageColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => widget.onSuccess(result), child: Text(AppStrings.dialogOk)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 8.0,
            right: 8.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32.0,
              child: Icon(iconData, size: 60.0, color: messageColor),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ExecState { loading, success, error }
