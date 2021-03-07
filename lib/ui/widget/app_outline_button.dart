import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    @required this.label,
    @required this.onPressed,
    this.icon,
    this.isCircular = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Icon icon;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlineButton.icon(
        icon: icon,
        label: Text(label),
        textColor: Theme.of(context).accentColor,
        onPressed: onPressed,
      );
    } else {
      if (isCircular) {
        return _createCircular(context);
      } else {
        return _createNormal(context);
      }
    }
  }

  Widget _createNormal(BuildContext context) {
    return OutlineButton(
      child: Text(label, style: TextStyle(color: Theme.of(context).accentColor)),
      onPressed: onPressed,
    );
  }

  Widget _createCircular(BuildContext context) {
    return OutlineButton(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Text(label, style: TextStyle(color: Theme.of(context).accentColor)),
      onPressed: onPressed,
    );
  }
}
