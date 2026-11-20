import 'package:flutter/material.dart';
import 'package:flutter_cvjasmine/connexionpage.dart';

void main() => runApp(const MonCvApp());

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10161C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          secondary: const Color(0xFFFBBF24),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF10161C),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const ConnexionPage(),
    );
  }
}
