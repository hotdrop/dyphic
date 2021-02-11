import 'package:dalico/common/app_strings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.settingsPageTitle),
      ),
      body: Center(
        child: Text('test'),
      ),
    );
  }
}
