import 'package:dyphic/ui/condition/condition_page.dart';
import 'package:dyphic/ui/medicine/medicine_page.dart';
import 'package:flutter/material.dart';
import 'package:dyphic/ui/calender/calendar_page.dart';
import 'package:dyphic/ui/note/notes_page.dart';
import 'package:dyphic/ui/setting/settings_page.dart';
import 'package:line_icons/line_icons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _menuView(_currentIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        items: _allDestinations
            .map((menu) => BottomNavigationBarItem(
                  label: menu.title,
                  icon: Icon(menu.icon),
                ))
            .toList(),
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
        return const CalenderPage();
      case 1:
        return const MedicinePage();
      case 2:
        return const ConditionPage();
      case 3:
        return const NotesPage();
      default:
        return const SettingsPage();
    }
  }
}

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const _allDestinations = <Destination>[
  Destination('カレンダー', Icons.calendar_today),
  Destination('お薬', LineIcons.capsules),
  Destination('体調', Icons.sentiment_satisfied_rounded),
  Destination('ノート', LineIcons.edit),
  Destination('設定', Icons.settings),
];
