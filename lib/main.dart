import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const DashboardSaludApp());
}

class DashboardSaludApp extends StatelessWidget {
  const DashboardSaludApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Salud',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0F14),
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}