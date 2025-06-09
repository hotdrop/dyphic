import 'package:dyphic/initialize_provider.dart';
import 'package:dyphic/res/app_theme.dart';
import 'package:dyphic/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: '体調管理',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: ref.watch(initializerProvider).when(
            data: (_) => const MainPage(),
            error: (error, stackTrace) => _ViewErrorScreen('$error'),
            loading: () => const _ViewLoadingScreen(),
          ),
    );
  }
}

class _ViewLoadingScreen extends StatelessWidget {
  const _ViewLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体調管理'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('起動までしばらくお待ちください'),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _ViewErrorScreen extends StatelessWidget {
  const _ViewErrorScreen(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体調管理'),
      ),
      body: Center(
        child: Text(
          'エラーが発生しました。\n$errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
