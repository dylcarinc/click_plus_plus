import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:click_plus_plus/app%20properties/theme_provider.dart';
import 'package:click_plus_plus/app%20properties/Pages/home.dart';
import 'package:click_plus_plus/app%20properties/Pages/scoreboard_screen.dart';
import 'package:click_plus_plus/firebase_interface.dart';
import 'package:click_plus_plus/widgets/custom_button.dart';
import 'mock_firebase.dart';

void main() {
  setUp(() {
    // Initialize the mock Firebase
    firebase = TestFirebase();
  });

  group('ThemeProvider Tests', () {
    test('Initial theme should be light', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.isDarkMode, false);
    });

    test('Toggle theme should switch between light and dark', () {
      final themeProvider = ThemeProvider();
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
    });

    test('Theme data should match mode', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.themeData.brightness, Brightness.light);
      themeProvider.toggleTheme();
      expect(themeProvider.themeData.brightness, Brightness.dark);
    });
  });

  group('Widget Tests', () {
    testWidgets('HomeScreen has CustomRoundButton and score in AppBar',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Verify that the CustomRoundButton is present
      expect(find.byType(CustomRoundButton), findsOneWidget);

      // Verify that the AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Check for the presence of the score in the AppBar
      expect(find.widgetWithText(TextButton, '0'), findsOneWidget);

      // Verify that the settings icon is present in the AppBar
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('ScoreboardScreen has tabs', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ScoreboardScreen()));
      expect(find.text('All Users'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });
  });
}
