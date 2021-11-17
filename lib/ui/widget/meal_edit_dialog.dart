import 'package:flutter/material.dart';
import 'package:dyphic/res/app_strings.dart';

class MealEditDialog extends StatefulWidget {
  const MealEditDialog._(this.title, this.initValue, this.isEditable);

  final String title;
  final String initValue;
  final bool isEditable;

  @override
  _MealEditDialogState createState() => _MealEditDialogState();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String initValue,
    required bool isEditable,
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (ctx) => MealEditDialog._(title, initValue, isEditable),
    );
  }
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
        enabled: widget.isEditable,
        maxLines: 7,
        decoration: const InputDecoration(
          labelText: AppStrings.recordMealDialogHint,
          border: OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.dialogCancel),
        ),
        TextButton(
          onPressed: (widget.isEditable) ? () => Navigator.pop<String>(context, _controller.text) : null,
          child: const Text(AppStrings.dialogOk),
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
