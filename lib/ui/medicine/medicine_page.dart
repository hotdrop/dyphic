import 'package:dalico/common/app_strings.dart';
import 'package:flutter/material.dart';

class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.medicinePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('test'),
          ],
        ),
      ),
    );
  }
}
