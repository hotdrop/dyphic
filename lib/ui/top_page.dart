import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/calender/calendar_page.dart';
import 'package:dyphic/ui/note/notes_page.dart';
import 'package:dyphic/ui/setting/settings_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage._();

  static Future<void> start(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
    await Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const TopPage._(),
      ),
    );
  }

  static const String routeName = '/top';

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _menuView(_currentIdx)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        items: _allDestinations.map((menu) {
          return BottomNavigationBarItem(
            label: menu.title,
            icon: Icon(menu.icon),
          );
        }).toList(),
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
  Destination(AppStrings.calenderPageTitle, Icons.calendar_today),
  Destination(AppStrings.notesPageTitle, Icons.sticky_note_2),
  Destination(AppStrings.settingsPageTitle, Icons.settings),
];
