import 'package:flutter/material.dart';

import 'config.dart';
import 'screens/home_screen.dart';
import 'services/content_repository.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class TechLearnApp extends StatefulWidget {
  const TechLearnApp({super.key});

  @override
  State<TechLearnApp> createState() => _TechLearnAppState();
}

class _TechLearnAppState extends State<TechLearnApp> {
  late final AppState _state = AppState(ContentRepository())..init();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) => MaterialApp(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _state.themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
