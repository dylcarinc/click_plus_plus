import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {  
  ThemeMode _themeMode = ThemeMode.light;  
  ThemeMode get themeMode => _themeMode;  
  bool get isDarkMode => _themeMode == ThemeMode.dark;  
  
  void toggleTheme() {   
     _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;    
     notifyListeners();  
}  
ThemeData get themeData {    
  return isDarkMode ? ThemeData.dark() : ThemeData.light();  
  }}