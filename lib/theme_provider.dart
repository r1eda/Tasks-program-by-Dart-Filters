import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Add more light theme configurations here
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Add more dark theme configurations here
  );
   static final IconData moonIcon = Icons.nightlight_round; // أيقونة القمر
  static final IconData sunIcon = Icons.wb_sunny; // أيقونة الشمس
}