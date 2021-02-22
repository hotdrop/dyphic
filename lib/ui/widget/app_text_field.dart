import 'package:dyphic/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField._(
    this.label,
    this.initValue,
    this.isRequired,
    this.limitLine,
    this.hintText,
    this.onChanged,
  );

  factory AppTextField.singleLine({
    @required String label,
    String initValue,
    bool isRequired = false,
    String hintText = '',
    @required void Function(String) onChanged,
  }) {
    return AppTextField._(label, initValue, isRequired, 1, hintText, onChanged);
  }

  factory AppTextField.multiLine({
    String initValue,
    bool isRequired = false,
    int limitLine = 6,
    String hintText = '',
    @required void Function(String) onChanged,
  }) {
    return AppTextField._('', initValue, isRequired, limitLine, hintText, onChanged);
  }

  final String label;
  final String initValue;
  final bool isRequired;
  final int limitLine;
  final String hintText;
  final void Function(String) onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String _value;

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
        if (widget.isRequired && _value != null && _value.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(AppStrings.textFieldRequiredEmptyError, style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  TextFormField _createTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        hintText: widget.hintText,
      ),
      initialValue: widget.initValue,
      maxLines: widget.limitLine,
      onChanged: (v) {
        setState(() {
          widget.onChanged(v);
        });
      },
    );
  }
}
