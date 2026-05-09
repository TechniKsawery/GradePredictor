// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradepredictor/main.dart';
import 'package:gradepredictor/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://uaeimifolckkhnsofluy.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhZWltaWZvbGNra2huc29mbHV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODc1NzQsImV4cCI6MjA5Mzg2MzU3NH0.ChbVEAKQZkrHP25ougl8mWE1QJLwrxA_weDXx1kX_rg',
    );
  });

  testWidgets('App builds and shows login', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GradePredictorApp()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
