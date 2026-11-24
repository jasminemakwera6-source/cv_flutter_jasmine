import 'package:flutter/material.dart';

const fond = Color(0xFF10161C);
const carte = Color(0xFF1A232C);
const champ = Color(0xFF202C38);
const turquoise = Color(0xFF14B8A6);
const ambre = Color(0xFFFBBF24);

ThemeData construireTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: turquoise,
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: fond,
    colorScheme: base.copyWith(primary: turquoise, secondary: ambre),
    appBarTheme: const AppBarTheme(
      backgroundColor: fond,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: champ,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: turquoise, width: 2),
      ),
    ),
  );
}
