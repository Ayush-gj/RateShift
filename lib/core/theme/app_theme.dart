import 'package:flutter/material.dart';

class AppTheme {
  // Vibrant Neon for Dark Mode, Deep Green for Light Mode visibility
  static const Color darkModeAccent = Color(0xFF00FF7F);
  static const Color lightModeAccent = Color(0xFF007A33);
  static const Color accentRed = Color(0xFFFF3131);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F2F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: lightModeAccent, // Updated to darker green for readability
      surface: Colors.white,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A0A),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: darkModeAccent, // Retains the neon green
      surface: Color(0xFF1E1E1E),
    ),
    useMaterial3: true,
  );
}