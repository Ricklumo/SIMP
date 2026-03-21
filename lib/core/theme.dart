import 'package:flutter/material.dart';

class SimpTheme {
  static const Color azul = Color(0xFF1E3A8A);
  static const Color laranja = Color(0xFFF97316);
  static const Color verde = Color(0xFF10B981);
  static const Color vermelho = Color(0xFFEF4444);

  static ThemeData get theme => ThemeData(
    primaryColor: azul,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: azul),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
  );
}