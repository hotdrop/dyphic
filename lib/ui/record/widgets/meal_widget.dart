import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:dyphic/ui/record/record_controller.dart';
import 'package:dyphic/res/app_images.dart';

///
/// 朝食
///
class MealBreakfastWidget extends StatelessWidget {
  const MealBreakfastWidget({
    super.key,
    required this.currentValue,
    required this.onSubmitted,
  });

  final String? currentValue;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return _MealCard(
      color: AppTheme.mealBreakFast,
      iconImagePath: AppImages.mealBreakFast,
      initValue: currentValue ?? '',
      dialogTitle: '朝食',
      onSubmitted: onSubmitted,
    );
  }
}

///
/// 昼食
///
class MealLunchWidget extends StatelessWidget {
  const MealLunchWidget({
    super.key,
    required this.currentValue,
    required this.onSubmitted,
  });

  final String? currentValue;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return _MealCard(
      color: AppTheme.mealLunch,
      iconImagePath: AppImages.mealLunch,
      initValue: currentValue ?? '',
      dialogTitle: '昼食',
      onSubmitted: onSubmitted,
    );
  }
}

///
/// 夕食
///
class MealDinnerWidget extends StatelessWidget {
  const MealDinnerWidget({
    super.key,
    required this.currentValue,
    required this.onSubmitted,
  });

  final String? currentValue;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return _MealCard(
      color: AppTheme.mealDinner,
      iconImagePath: AppImages.mealDinner,
      initValue: currentValue ?? '',
      dialogTitle: '夕食',
      onSubmitted: onSubmitted,
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.color,
    required this.iconImagePath,
    required this.initValue,
    required this.dialogTitle,
    required this.onSubmitted,
  });

  final Color color;
  final String iconImagePath;
  final String initValue;
  final String dialogTitle;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: color,
        elevation: 4.0,
        child: InkWell(
          onTap: () async => await _showEditDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Image.asset(iconImagePath)),
                _detailLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final inputValue = await _MealEditDialog.show(
          context,
          title: dialogTitle,
          initValue: initValue,
        ) ??
        '';
    onSubmitted(inputValue);
  }

  Widget _detailLabel() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          initValue,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _MealEditDialog extends ConsumerStatefulWidget {
  const _MealEditDialog._(this.title, this.initValue);

  final String title;
  final String initValue;

  @override
  ConsumerState<_MealEditDialog> createState() => _MealEditDialogState();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String initValue,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _MealEditDialog._(title, initValue),
    );
  }
}

class _MealEditDialogState extends ConsumerState<_MealEditDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = ref.watch(isSignInProvider);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: _controller,
        enabled: isSignIn,
        maxLines: 7,
        decoration: const InputDecoration(
          labelText: '食事の内容(簡単に)',
          border: OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: isSignIn ? () => Navigator.pop<String>(context, _controller.text) : null,
          child: const Text('OK'),
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
