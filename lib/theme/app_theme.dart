import 'package:flutter/material.dart';
// Import the AppThemeData file which holds the light and dark theme data

class AppTheme with ChangeNotifier {
  // Default theme mode (you can change this to ThemeMode.dark if you want the dark theme to be the default)
  ThemeMode _themeMode = ThemeMode.light;

  // Getter for the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();  // Notify widgets to rebuild when theme changes
  }

  // Optionally, if you need specific control to switch directly to dark/light theme:
  
  // Switch to dark theme
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  // Switch to light theme
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}
