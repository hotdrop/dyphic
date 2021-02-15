import 'package:dalico/common/app_strings.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField._(this.label, this.initValue, this.isRequired, this.limitLine, this.onChanged);

  factory AppTextField.singleLine({
    @required String label,
    String initValue,
    bool isRequired = false,
    @required void Function(String) onChanged,
  }) {
    return AppTextField._(label, initValue, isRequired, 1, onChanged);
  }

  factory AppTextField.multiLine({
    String initValue,
    bool isRequired = false,
    @required void Function(String) onChanged,
  }) {
    return AppTextField._('', initValue, isRequired, 6, onChanged);
  }

  final String label;
  final String initValue;
  final bool isRequired;
  final int limitLine;
  final void Function(String) onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState(label, initValue, isRequired, limitLine, onChanged);
}

class _AppTextFieldState extends State<AppTextField> {
  _AppTextFieldState(this.label, this.initValue, this.isRequired, this.limitLine, this.onChanged);

  final String label;
  final bool isRequired;
  final String initValue;
  final int limitLine;
  final void Function(String) onChanged;

  String _value;

  @override
  void initState() {
    super.initState();
    _value = initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createTextFormField(),
        if (isRequired && _value != null && _value.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(AppStrings.textFieldRequiredEmptyError, style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  TextFormField _createTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      initialValue: initValue,
      maxLines: limitLine,
      onChanged: (v) {
        setState(() {
          onChanged(v);
        });
      },
    );
  }
}
