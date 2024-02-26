import 'package:flutter/cupertino.dart';
import 'package:Adhyayan/viewmodels/global_ui_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/screens/auth/register_screen.dart';

// Mock GlobalUIViewModel
class MockGlobalUIViewModel extends GlobalUIViewModel {}

void main() {
  testWidgets('Register Screen UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<GlobalUIViewModel>(
        create: (_) => MockGlobalUIViewModel(),
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );


    expect(find.text('Create Account'), findsOneWidget);


  });
}
