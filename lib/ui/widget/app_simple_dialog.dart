import 'package:flutter/material.dart';

import 'package:dyphic/common/app_strings.dart';

class AppSimpleDialog {
  const AppSimpleDialog({required this.message});

  final String message;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.dialogOk),
            )
          ],
        );
      },
    );
  }
}
