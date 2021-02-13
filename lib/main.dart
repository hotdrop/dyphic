import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:dalico/common/app_theme.dart';
import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/app_settings.dart';
import 'package:dalico/ui/main_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettings>(
      future: AppSettings.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _SplashScreen();
        } else {
          return ChangeNotifierProvider<AppSettings>(
            create: (_) => snapshot.data,
            child: _MyApp(),
          );
        }
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', ''),
      ],
      title: AppStrings.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: Provider.of<AppSettings>(context).isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainPage(),
    );
  }
}
