// https://medium.com/@blup-tool/learn-how-to-implement-dark-mode-and-light-mode-in-your-flutter-app-f90df3f9cdc8
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Colors.white
  )
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(137, 43, 43, 43)
  )
);




