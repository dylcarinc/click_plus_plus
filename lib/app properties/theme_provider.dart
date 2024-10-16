import 'package:click_plus_plus/app%20properties/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  // changes the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void themeToggle() {
    if (themeData == lightTheme) {
      themeData = darkTheme;
    }
    else {
      themeData = lightTheme;
    }

  }
}