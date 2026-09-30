import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class PatientRecordApp extends StatelessWidget {
  const PatientRecordApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        title: 'Patient Record App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: appState.isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
