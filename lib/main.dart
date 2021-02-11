import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dalico/common/app_theme.dart';
import 'package:dalico/common/app_strings.dart';
import 'package:dalico/model/app_settings.dart';
import 'package:dalico/ui/main_page.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final futureFunc = useMemoized(() => AppSettings.create());
    final snapshot = useFuture(futureFunc);
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
        themeMode: snapshot.data.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: MainPage(),
      );
    }
  }
}
