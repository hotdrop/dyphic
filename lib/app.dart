import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/ui/start/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: AppStrings.appTitle,
      theme: isDarkMode ? AppTheme.dark : AppTheme.light,
      home: const SplashPage(),
    );
  }
}
