import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:referral_test/main.dart';
import 'package:referral_test/src/data/providers.dart';

Widget buildTestApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const JenosizeApp(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders a MaterialApp without crashing', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(buildTestApp(prefs));
    await tester.pump(); // one frame
    expect(find.byType(MaterialApp), findsOneWidget);
    // Settle all pending timers to avoid leaks
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });

  testWidgets('Home screen shows Active Campaigns text', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(buildTestApp(prefs));
    // Let async providers resolve
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Active Campaigns'), findsOneWidget);
  });

  testWidgets('Bottom navigation bar renders with 4 items', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(buildTestApp(prefs));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    // Verify the BottomNavigationBar exists and contains 4 items
    final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(navBar.items.length, 4);
  });
}
