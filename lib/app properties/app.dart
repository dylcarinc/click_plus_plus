import 'package:click_plus_plus/app%20properties/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:click_plus_plus/app properties/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: AppRouter.authGate,
      onGenerateRoute: AppRouter.generateRoute,

    );
  }
}
