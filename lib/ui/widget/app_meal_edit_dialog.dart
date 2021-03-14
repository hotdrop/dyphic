import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppMealEditDialog extends StatefulWidget {
  const AppMealEditDialog({
    required this.title,
    required this.initValue,
  });

  final String title;
  final String initValue;

  @override
  _AppMealEditDialogState createState() => _AppMealEditDialogState();
}

class _AppMealEditDialogState extends State<AppMealEditDialog> {
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
        maxLines: 3,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop<String>(context, _controller.text),
          child: Text(AppStrings.dialogOk),
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
