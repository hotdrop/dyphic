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
        return _loadSuccessView(context);
      case _ExecState.error:
        return _loadErrorView();
      default:
        return _loadingView();
    }
  }

  Widget _loadingView() {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return _createDialog(
      icon: Icon(
        Icons.info,
        color: Theme.of(context).accentColor,
      ),
      messageView: Text(AppStrings.dialogSuccessMessage, style: TextStyle(color: Theme.of(context).accentColor)),
      result: true,
    );
  }

  Widget _loadErrorView() {
    return _createDialog(
      icon: Icon(Icons.error, color: Colors.red),
      messageView: Text(AppStrings.dialogErrorMessage, style: TextStyle(color: Colors.red)),
      result: false,
    );
  }

  Widget _createDialog({required Widget icon, required Widget messageView, required bool result}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 8.0),
                messageView,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => widget.onSuccess(result), child: Text(AppStrings.dialogOk)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _ExecState { loading, success, error }
