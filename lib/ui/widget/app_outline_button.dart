import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isCircular = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Icon? icon;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        icon: icon!,
        label: Text(label, style: TextStyle(color: Theme.of(context).accentColor)),
        onPressed: onPressed,
      );
    } else {
      if (isCircular) {
        return _createCircularBorder(context);
      } else {
        return _createNormal(context);
      }
    }
  }

  Widget _createNormal(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Theme.of(context).accentColor)),
    );
  }

  Widget _createCircularBorder(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        textStyle: TextStyle(color: Theme.of(context).accentColor),
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      child: Text(label, style: TextStyle(color: Theme.of(context).accentColor)),
    );
  }
}
