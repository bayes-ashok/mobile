import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:Adhyayan/screens/auth/register_screen.dart';

void main() {
  testWidgets('Register Screen UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // Verify if certain widgets are present on the screen
    expect(find.text('Adhyayan'), findsOneWidget);
    expect(find.text('Create your Adhyayan account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
