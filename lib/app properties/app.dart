import 'package:click_plus_plus/app%20properties/theme.dart';
import 'package:click_plus_plus/app%20properties/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:click_plus_plus/main.dart';
import 'package:provider/provider.dart';

import '../auth_gate.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthGate(),
    );
  }
}

/*ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        */