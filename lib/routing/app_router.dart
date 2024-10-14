import 'package:flutter/material.dart';
import 'package:click_plus_plus/app%20properties/Pages/home.dart';
import 'package:click_plus_plus/auth_gate.dart';
import 'package:click_plus_plus/app%20properties/Pages/scoreboard_screen.dart';
import 'package:click_plus_plus/app%20properties/Pages/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppRouter {
  static const String authGate = '/';
  static const String home = '/home';
  static const String scoreboard = '/scoreboard';
  static const String userProfile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case scoreboard:
        return MaterialPageRoute(builder: (_) => const ScoreboardScreen());
      case userProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'] as String?;
        if (userId != null) {
          return MaterialPageRoute(
              builder: (_) => UserProfileScreen(userId: userId));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }

  static Future<void> navigateTo(BuildContext context, String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (FirebaseAuth.instance.currentUser == null && routeName != authGate) {
      await Navigator.pushReplacementNamed(context, authGate);
    } else {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
