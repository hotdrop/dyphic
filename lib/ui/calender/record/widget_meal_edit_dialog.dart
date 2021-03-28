import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class MealEditDialog extends StatefulWidget {
  const MealEditDialog({
    required this.title,
    required this.initValue,
    required this.isLogin,
  });

  final String title;
  final String initValue;
  final bool isLogin;

  @override
  _MealEditDialogState createState() => _MealEditDialogState();
}

class _MealEditDialogState extends State<MealEditDialog> {
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
      content: TextField(
        autofocus: true,
        controller: _controller,
        enabled: widget.isLogin,
        maxLines: 7,
        decoration: InputDecoration(
          labelText: AppStrings.recordMealDialogHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: (widget.isLogin) ? () => Navigator.pop<String>(context, _controller.text) : null,
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
