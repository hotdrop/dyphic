import 'package:dyphic/model/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealEditDialog extends ConsumerStatefulWidget {
  const MealEditDialog._(this.title, this.initValue);

  final String title;
  final String initValue;

  @override
  _MealEditDialogState createState() => _MealEditDialogState();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String initValue,
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (ctx) => MealEditDialog._(title, initValue),
    );
  }
}

class _MealEditDialogState extends ConsumerState<MealEditDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: _controller,
        enabled: isSignIn,
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
          onPressed: isSignIn ? () => Navigator.pop<String>(context, _controller.text) : null,
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
