import 'package:flutter/material.dart';

import 'package:dyphic/common/app_extension.dart';
import 'package:dyphic/common/app_strings.dart';

class AppTextField extends StatefulWidget {
  const AppTextField._(
    this.label,
    this.initValue,
    this.isRequired,
    this.hintText,
    this.onChanged,
  );

  factory AppTextField.singleLine({
    required String label,
    String? initValue,
    bool isRequired = false,
    String hintText = '',
    required void Function(String) onChanged,
  }) {
    return AppTextField._(label, initValue, isRequired, hintText, onChanged);
  }

  final String label;
  final String? initValue;
  final bool isRequired;
  final String hintText;
  final void Function(String) onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createTextFormField(),
        if (widget.isRequired && _value.haveValue())
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              AppStrings.textFieldRequiredEmptyError,
              style: TextStyle(color: Colors.red, fontSize: 12.0),
            ),
          ),
      ],
    );
  }

  TextFormField _createTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      initialValue: widget.initValue,
      onChanged: (String value) {
        setState(() {
          widget.onChanged(value);
        });
      },
    );
  }
}

///
/// 複数行のテキストフィールド
///
class MultiLineTextField extends StatefulWidget {
  const MultiLineTextField({
    required this.label,
    required this.initValue,
    required this.limitLine,
    required this.hintText,
    required this.onChanged,
  });

  final String label;
  final String? initValue;
  final int limitLine;
  final String hintText;
  final void Function(String) onChanged;

  @override
  _MultiLineTextFieldState createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.limitLine,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
      ),
      style: TextStyle(fontSize: 14.0),
      onChanged: (String value) => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
