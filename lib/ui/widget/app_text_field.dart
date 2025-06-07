import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.initValue,
    this.isRequired = false,
    this.hintText = '',
    required this.onChanged,
  });

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
        if (widget.isRequired && _haveValue())
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              '※必須項目',
              style: TextStyle(color: Colors.red, fontSize: 12.0),
            ),
          ),
      ],
    );
  }

  bool _haveValue() => _value?.isNotEmpty ?? false;

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
    super.key,
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
  State<MultiLineTextField> createState() => _MultiLineTextFieldState();
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
      style: const TextStyle(fontSize: 14.0),
      onChanged: (String value) => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
