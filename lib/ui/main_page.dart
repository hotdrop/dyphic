import 'package:flutter/material.dart';

import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/ui/calender/calendar_page.dart';
import 'package:dyphic/ui/medicine/medicine_page.dart';
import 'package:dyphic/ui/setting/settings_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: _menuView(_currentIdx)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        elevation: 12.0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        items: _allDestinations.map((item) => BottomNavigationBarItem(label: item.title, icon: Icon(item.icon))).toList(),
        onTap: (i) {
          setState(() {
            _currentIdx = i;
          });
        },
      ),
    );
  }

  Widget _menuView(int index) {
    switch (index) {
      case 0:
        return CalenderPage();
      case 1:
        return MedicinePage();
      default:
        return SettingsPage();
    }
  }
}

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const _allDestinations = <Destination>[
  Destination(AppStrings.calenderPageTitle, Icons.calendar_today),
  Destination(AppStrings.medicinePageTitle, Icons.medical_services),
  Destination(AppStrings.settingsPageTitle, Icons.settings),
];
