import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.green,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Color.fromARGB(179, 94, 94, 94),
    selectedItemColor: Colors.green,
    elevation: 20,
  ),
);
